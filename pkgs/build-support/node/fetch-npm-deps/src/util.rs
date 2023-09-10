use backoff::{retry, ExponentialBackoff};
use isahc::{
    config::{CaCertificate, Configurable, RedirectPolicy, SslOption},
    Body, Request, RequestExt,
};
use std::{env, path::Path};
use url::Url;

pub fn get_url(url: &Url) -> Result<Body, isahc::Error> {
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

    Ok(request.body(())?.send()?.into_body())
}

pub fn get_url_with_retry(url: &Url) -> Result<Body, isahc::Error> {
    retry(ExponentialBackoff::default(), || {
        get_url(url).map_err(|err| {
            if err.is_network() || err.is_timeout() {
                backoff::Error::transient(err)
            } else {
                backoff::Error::permanent(err)
            }
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
