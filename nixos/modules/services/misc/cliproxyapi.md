# CLIProxyAPI {#module-services-cliproxyapi}

[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) exposes OAuth-based subscription CLIs (Claude Code, Codex, Gemini, Qwen, Grok, Antigravity) behind OpenAI/Gemini/Anthropic-compatible HTTP APIs.

Enable it with:

```nix
{
  services.cliproxyapi.enable = true;
}
```

The service runs as a dedicated `cliproxyapi` user and keeps its configuration and OAuth tokens under `/var/lib/cliproxyapi`.

## Authentication {#module-services-cliproxyapi-authentication}

Provider logins use OAuth and must land in the service's `auth-dir` (`/var/lib/cliproxyapi`), which is owned by the `cliproxyapi` user. Either of the approaches below writes the token with the correct ownership, and the running service picks it up without a restart.

### Management API {#module-services-cliproxyapi-authentication-management-api}

Set a management key in [](#opt-services.cliproxyapi.settings):

```nix
{
  services.cliproxyapi.settings.remote-management.secret-key._secret =
    "/run/secrets/cliproxyapi-mgmt-key";
}
```

Then request an authentication URL for the desired provider and open it in a browser:

```bash
curl -H "Authorization: Bearer <management-key>" \
  http://127.0.0.1:8317/v0/management/anthropic-auth-url
```

The daemon completes the OAuth flow itself and stores the token in its `auth-dir`. Authentication endpoints are available for the `anthropic`, `codex`, `xai`, `antigravity`, and `kimi` providers.

### Command-line login {#module-services-cliproxyapi-authentication-cli}

Add the package so the `cliproxyapi` binary is on `PATH`:

```nix
{
  environment.systemPackages = [ config.services.cliproxyapi.package ];
}
```

Then run the login as the service user, pointing at the managed configuration:

```bash
sudo -u cliproxyapi cliproxyapi -config /var/lib/cliproxyapi/config.yaml --claude-login
```

Other providers use their matching flags, for example `--codex-login` or `--xai-login`. On a headless host, pass `-no-browser` to print the OAuth URL instead of launching a browser.
