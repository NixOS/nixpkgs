use arkhe_auth_md::{claims::PendingClaim, service::Service, token::*, Error};
use ed25519_dalek::SigningKey;

fn fixture() -> (Issuer, Trust, Claims) {
    let issuer = Issuer::new(
        "https://provider.example".into(),
        "k1".into(),
        SigningKey::from_bytes(&[7; 32]),
    );
    let trust = Trust {
        issuer: "https://provider.example".into(),
        kid: "k1".into(),
        key: issuer.public_key(),
        audience: "https://auth.example".into(),
        client_id: "agent".into(),
        max_lifetime: 600,
        max_auth_age: 3600,
    };
    let claims = Claims {
        iss: trust.issuer.clone(),
        sub: "user-1".into(),
        aud: trust.audience.clone(),
        client_id: "agent".into(),
        jti: "nonce-1".into(),
        iat: 100,
        exp: 600,
        auth_time: 90,
        email: "user@example.com".into(),
        email_verified: true,
        scope: "community:join community:post".into(),
        registration_id: "provider-registration".into(),
    };
    (issuer, trust, claims)
}

#[test]
fn strict_signature_identity_time_scope_and_replay() {
    let (issuer, mut trust, mut c) = fixture();
    let jwt = issuer.sign(&c, ID_JAG).unwrap();
    let mut state = TokenState::default();
    assert!(verify_registration(&jwt, &trust, 101, &mut state).is_ok());
    assert!(matches!(
        verify_registration(&jwt, &trust, 101, &mut state),
        Err(Error::Replay)
    ));
    assert!(matches!(
        verify(&jwt, ACCESS, &trust, 101, &[], &mut state),
        Err(Error::Untrusted)
    ));
    assert!(matches!(
        verify(&jwt, ID_JAG, &trust, 600, &[], &mut state),
        Err(Error::Expired)
    ));
    assert!(matches!(
        verify(&jwt, ID_JAG, &trust, 101, &["admin"], &mut state),
        Err(Error::Scope)
    ));
    trust.audience = "https://attacker.example".into();
    assert!(matches!(
        verify(&jwt, ID_JAG, &trust, 101, &[], &mut state),
        Err(Error::Untrusted)
    ));
    trust.audience = c.aud.clone();
    trust.key = SigningKey::from_bytes(&[8; 32]).verifying_key();
    assert!(matches!(
        verify(&jwt, ID_JAG, &trust, 101, &[], &mut state),
        Err(Error::InvalidToken)
    ));
    trust.key = issuer.public_key();
    c.email_verified = false;
    assert!(matches!(
        verify(
            &issuer.sign(&c, ID_JAG).unwrap(),
            ID_JAG,
            &trust,
            101,
            &[],
            &mut state
        ),
        Err(Error::InvalidToken)
    ));
    c.email_verified = true;
    c.iat = 102;
    assert!(matches!(
        verify(
            &issuer.sign(&c, ID_JAG).unwrap(),
            ID_JAG,
            &trust,
            101,
            &[],
            &mut state
        ),
        Err(Error::Expired)
    ));
}

#[test]
fn registration_exchange_and_both_revocation_layers() {
    let (provider, trust, c) = fixture();
    let mut service = Service::new(
        "https://auth.example".into(),
        "https://orkut.example".into(),
        "service-key".into(),
        SigningKey::from_bytes(&[9; 32]),
    );
    let registration = service
        .register_provider(
            &provider.sign(&c, ID_JAG).unwrap(),
            &trust,
            101,
            &["community:join".into()],
        )
        .unwrap();
    let response = service
        .exchange(
            &registration.identity_assertion,
            "https://orkut.example",
            102,
        )
        .unwrap();
    let access_trust = service.access_trust();
    assert!(verify(
        &response.access_token,
        ACCESS,
        &access_trust,
        103,
        &["community:join"],
        service.token_state()
    )
    .is_ok());
    service.revoke_token(&response.access_token);
    assert!(matches!(
        verify(
            &response.access_token,
            ACCESS,
            &access_trust,
            103,
            &[],
            service.token_state()
        ),
        Err(Error::Revoked)
    ));
    // Revoking one bearer does not revoke the registration assertion.
    let second = service
        .exchange(
            &registration.identity_assertion,
            "https://orkut.example",
            104,
        )
        .unwrap();
    service.revoke_provider_subject(&c.iss, &c.sub);
    assert!(matches!(
        service.exchange(
            &registration.identity_assertion,
            "https://orkut.example",
            105
        ),
        Err(Error::Revoked)
    ));
    assert!(matches!(
        verify(
            &second.access_token,
            ACCESS,
            &access_trust,
            105,
            &[],
            service.token_state()
        ),
        Err(Error::Revoked)
    ));
}

#[test]
fn claim_requires_confirmation_expires_and_locks_after_five_attempts() {
    let (mut claim, code) = PendingClaim::new(100).unwrap();
    assert!(claim.take_subject(101).is_err());
    claim.confirm(&code, "authenticated-user", 101).unwrap();
    assert_eq!(claim.take_subject(102).unwrap(), "authenticated-user");
    assert!(claim.take_subject(103).is_err());
    let (mut expired, code) = PendingClaim::new(100).unwrap();
    assert!(expired.confirm(&code, "user", 700).is_err());
    let (mut locked, code) = PendingClaim::new(100).unwrap();
    for _ in 0..5 {
        assert!(locked.confirm("invalid", "user", 101).is_err());
    }
    assert!(locked.confirm(&code, "user", 102).is_err());
}

#[test]
fn discovery_rejects_injected_urls() {
    let d = arkhe_auth_md::protocol::Discovery {
        resource: "https://orkut.example".into(),
        issuer: "https://auth.example".into(),
        scopes_supported: vec!["community:join".into()],
    };
    assert!(d.protected_resource().is_ok());
    let bad = arkhe_auth_md::protocol::Discovery {
        resource: "https://orkut.example\nInjected".into(),
        ..d
    };
    assert!(bad.auth_md().is_err());
}
