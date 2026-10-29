//! Public low-cardinality HTTP metrics and OTLP request/pipeline spans.
//! Query strings, bodies, JWTs and tenant identifiers are not telemetry attributes.
use axum::{
    extract::{MatchedPath, Request},
    middleware::{self, Next},
    response::Response,
    routing::get,
    Router,
};
use axum_prometheus::{EndpointLabel, PrometheusMetricLayerBuilder};
use metrics_exporter_prometheus::{PrometheusBuilder, PrometheusHandle};
use opentelemetry::{global, propagation::Extractor, trace::TracerProvider};
use opentelemetry_sdk::{propagation::TraceContextPropagator, trace::SdkTracerProvider, Resource};
use std::{collections::HashMap, sync::OnceLock};
use tracing::Instrument;
use tracing_opentelemetry::OpenTelemetrySpanExt;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt, EnvFilter};

fn metrics() -> &'static PrometheusHandle {
    static HANDLE: OnceLock<PrometheusHandle> = OnceLock::new();
    HANDLE.get_or_init(|| {
        let handle = PrometheusBuilder::new()
            .set_buckets_for_metric(
                metrics_exporter_prometheus::Matcher::Full(
                    "axum_http_requests_duration_seconds".into(),
                ),
                &[
                    0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1.0, 2.5, 5.0, 10.0, 30.0,
                ],
            )
            .expect("valid metric buckets")
            .install_recorder()
            .expect("metrics recorder already installed");
        metrics::describe_counter!(
            "arkhe_gate_decisions_total",
            "Citation support gate outcomes, independent of HTTP journal success"
        );
        handle
    })
}
pub fn instrument(app: Router) -> Router {
    let handle = metrics().clone();
    let layer = PrometheusMetricLayerBuilder::new()
        .with_endpoint_label_type(EndpointLabel::MatchedPathWithFallbackFn(|_| {
            "unmatched".into()
        }))
        .build();
    app.route(
        "/metrics",
        get(move || {
            let handle = handle.clone();
            async move {
                handle.run_upkeep();
                (
                    [(
                        axum::http::header::CONTENT_TYPE,
                        "text/plain; version=0.0.4; charset=utf-8",
                    )],
                    handle.render(),
                )
            }
        }),
    )
    .layer(layer)
    .layer(middleware::from_fn(http_span))
}
struct Headers<'a>(&'a axum::http::HeaderMap);
impl Extractor for Headers<'_> {
    fn get(&self, key: &str) -> Option<&str> {
        self.0.get(key).and_then(|v| v.to_str().ok())
    }
    fn keys(&self) -> Vec<&str> {
        self.0.keys().map(|k| k.as_str()).collect()
    }
}
async fn http_span(request: Request, next: Next) -> Response {
    let route = request
        .extensions()
        .get::<MatchedPath>()
        .map(MatchedPath::as_str)
        .unwrap_or("unmatched");
    let method = match request.method().as_str() {
        "GET" | "HEAD" | "POST" | "PUT" | "DELETE" | "CONNECT" | "OPTIONS" | "TRACE" | "PATCH" => {
            request.method().as_str()
        }
        _ => "_OTHER",
    };
    let span_method = if method == "_OTHER" { "HTTP" } else { method };
    let name = if route == "unmatched" {
        span_method.to_string()
    } else {
        format!("{span_method} {route}")
    };
    let span = tracing::info_span!("http.server",
        otel.name=%name, otel.kind="server", http.request.method=method, http.route=route,
        http.response.status_code=tracing::field::Empty, otel.status_code=tracing::field::Empty);
    let parent = global::get_text_map_propagator(|p| p.extract(&Headers(request.headers())));
    let _ = span.set_parent(parent);
    let response = next.run(request).instrument(span.clone()).await;
    span.record(
        "http.response.status_code",
        response.status().as_u16() as i64,
    );
    if response.status().is_server_error() {
        span.record("otel.status_code", "ERROR");
    }
    response
}
pub async fn init() -> Result<Option<SdkTracerProvider>, String> {
    let filter =
        EnvFilter::try_from_default_env().unwrap_or_else(|_| EnvFilter::new("arkhe_ask=info"));
    let fmt = tracing_subscriber::fmt::layer()
        .json()
        .with_current_span(false)
        .with_span_list(false);
    let endpoint = std::env::var("OTEL_EXPORTER_OTLP_TRACES_ENDPOINT")
        .ok()
        .filter(|s| !s.trim().is_empty());
    if let Some(endpoint) = endpoint {
        use opentelemetry_otlp::WithExportConfig;
        let exporter = tokio::task::spawn_blocking(move || {
            opentelemetry_otlp::SpanExporter::builder()
                .with_http()
                .with_endpoint(endpoint)
                .with_timeout(std::time::Duration::from_secs(5))
                .build()
                .map_err(|e| e.to_string())
        })
        .await
        .map_err(|e| e.to_string())??;
        let service = std::env::var("OTEL_SERVICE_NAME").unwrap_or_else(|_| "arkhe-ask".into());
        let provider = SdkTracerProvider::builder()
            .with_batch_exporter(exporter)
            .with_resource(Resource::builder().with_service_name(service).build())
            .build();
        let tracer = provider.tracer("arkhe-ask");
        global::set_tracer_provider(provider.clone());
        global::set_text_map_propagator(TraceContextPropagator::new());
        tracing_subscriber::registry()
            .with(filter)
            .with(fmt)
            .with(tracing_opentelemetry::layer().with_tracer(tracer))
            .try_init()
            .map_err(|e| e.to_string())?;
        Ok(Some(provider))
    } else {
        tracing_subscriber::registry()
            .with(filter)
            .with(fmt)
            .try_init()
            .map_err(|e| e.to_string())?;
        Ok(None)
    }
}
pub async fn shutdown_signal() {
    #[cfg(unix)]
    {
        let mut terminate =
            tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())
                .expect("SIGTERM handler");
        tokio::select! {_=tokio::signal::ctrl_c()=>{},_=terminate.recv()=>{}}
    }
    #[cfg(not(unix))]
    {
        let _ = tokio::signal::ctrl_c().await;
    }
}

/// Whitelisted W3C metadata only; it is persisted independently of proof commitments.
pub fn capture_context() -> HashMap<String, String> {
    let mut context = HashMap::new();
    global::get_text_map_propagator(|p| {
        p.inject_context(&tracing::Span::current().context(), &mut context)
    });
    context.retain(|k, v| matches!(k.as_str(), "traceparent" | "tracestate") && v.len() <= 512);
    context
}
pub fn restore_parent(span: &tracing::Span, context: &HashMap<String, String>) {
    let parent = global::get_text_map_propagator(|p| p.extract(context));
    let _ = span.set_parent(parent);
}
