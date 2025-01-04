use anyhow::bail;
use backoff::{retry, ExponentialBackoff};
use data_encoding::BASE64;
use digest::Digest;
use isahc::{
    config::{CaCertificate, Configurable, RedirectPolicy, SslOption},
    Body, Request, RequestExt,
};
use log::info;
use nix_nar::{Encoder, NarError};
use serde_json::{Map, Value};
use sha2::Sha256;
use std::{
    env,
    io::{self, Read},
    path::Path,
};
use url::Url;

pub fn get_url(url: &Url) -> Result<Body, anyhow::Error> {
    let mut request = Request::get(url.as_str()).redirect_policy(RedirectPolicy::Limit(10));

    // Respect SSL_CERT_FILE if environment variable exists
    if let Ok(ssl_cert_file) = env::var("SSL_CERT_FILE") {
        if Path::new(&ssl_cert_file).exists() {
            // When file exists, use it. NIX_SSL_CERT_FILE will still override.
            request = request.ssl_ca_certificate(CaCertificate::file(ssl_cert_file));
        } else if env::var("outputHash").is_ok() {
            // When file does not exist, assume we are downloading in a FOD and
            // therefore do not need to check certificates, since the output is
            // already hashed.
            request = request.ssl_options(SslOption::DANGER_ACCEPT_INVALID_CERTS);
        }
    }

    // Respect NIX_NPM_TOKENS environment variable, which should be a JSON mapping in the shape of:
    // `{ "registry.example.com": "example-registry-bearer-token", ... }`
    if let Some(host) = url.host_str() {
        if let Ok(npm_tokens) = env::var("NIX_NPM_TOKENS") {
            if let Ok(tokens) = serde_json::from_str::<Map<String, Value>>(&npm_tokens) {
                if let Some(token) = tokens.get(host).and_then(serde_json::Value::as_str) {
                    info!("Found NPM token for {}. Adding authorization header to request.", host);
                    request = request.header("Authorization", format!("Bearer {token}"));
                }
            }
        }
    }

    let res = request.body(())?.send()?;
    if !res.status().is_success() {
        if res.status().is_client_error() {
            bail!("Client error: {}", res.status());
        }
        if res.status().is_server_error() {
            bail!("Server error: {}", res.status());
        }
        bail!("{}", res.status());
    }
    Ok(res.into_body())
}

pub fn get_url_body_with_retry(url: &Url) -> Result<Vec<u8>, anyhow::Error> {
    retry(ExponentialBackoff::default(), || {
        get_url(url)
            .and_then(|mut body| {
                let mut buf = Vec::new();

                body.read_to_end(&mut buf)?;

                Ok(buf)
            })
            .map_err(|err| match err.downcast_ref::<isahc::Error>() {
                Some(isahc_err) => {
                    if isahc_err.is_network() || isahc_err.is_timeout() {
                        backoff::Error::transient(err)
                    } else {
                        backoff::Error::permanent(err)
                    }
                }
                None => backoff::Error::permanent(err),
            })
    })
    .map_err(|backoff_err| match backoff_err {
        backoff::Error::Permanent(err)
        | backoff::Error::Transient {
            err,
            retry_after: _,
        } => err,
    })
}

pub fn make_sri_hash(path: &Path) -> Result<String, NarError> {
    let mut encoder = Encoder::new(path)?;
    let mut hasher = Sha256::new();

    io::copy(&mut encoder, &mut hasher)?;

    Ok(format!("sha256-{}", BASE64.encode(&hasher.finalize())))
}
