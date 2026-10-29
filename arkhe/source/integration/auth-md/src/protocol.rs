//! Structured discovery is authoritative; Markdown is never parsed as executable policy.
use crate::Error;
use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Discovery {
    pub resource: String,
    pub issuer: String,
    pub scopes_supported: Vec<String>,
}
impl Discovery {
    pub fn validate(&self) -> Result<(), Error> {
        // This local profile uses HTTPS origins only, preventing injected paths/headers in templates.
        let origin = |s: &str| {
            s.strip_prefix("https://").is_some_and(|host| {
                !host.is_empty()
                    && host.contains('.')
                    && host
                        .bytes()
                        .all(|b| b.is_ascii_alphanumeric() || b == b'.' || b == b'-')
            })
        };
        if !origin(&self.resource)
            || !origin(&self.issuer)
            || self.scopes_supported.is_empty()
            || self.scopes_supported.iter().any(|s| {
                s.is_empty()
                    || !s
                        .bytes()
                        .all(|b| b.is_ascii_alphanumeric() || b"_:.-".contains(&b))
            })
        {
            return Err(Error::Discovery);
        }
        Ok(())
    }
    pub fn protected_resource(&self) -> Result<serde_json::Value, Error> {
        self.validate()?;
        Ok(
            serde_json::json!({"resource": self.resource, "authorization_servers": [self.issuer], "scopes_supported": self.scopes_supported, "bearer_methods_supported": ["header"]}),
        )
    }
    /// Local metadata describes library capabilities, not a deployed or certified OAuth server.
    pub fn auth_md(&self) -> Result<String, Error> {
        self.validate()?;
        Ok(format!("# auth.md\n\nArkhe Orkut integration candidate.\n\n## 1. Discover\n\nRead {}/.well-known/oauth-protected-resource. Structured metadata is authoritative.\n\n## 2. Register\n\nThe host must deploy /agent/identity, /oauth2/token, /oauth2/revoke and authenticated claim confirmation before advertising supported flows. Provider assertions require a pinned issuer, key, audience and client plus fresh verified identity. Service assertions are exchanged separately for access tokens.\n\n## 3. Scopes\n\n{}\n\n## 4. Claims and revocation\n\nConfirm a claim only in an authenticated host session. Registration revocation invalidates its assertions and derived credentials.\n", self.resource, self.scopes_supported.join(", ")))
    }
}
