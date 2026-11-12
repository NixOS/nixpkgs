# CLIProxyAPI {#module-services-cliproxyapi}

[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) exposes OAuth-based subscription CLIs (Claude Code, Codex, Grok, Antigravity, Kimi, Devin, Meta) behind OpenAI/Gemini/Anthropic-compatible HTTP APIs.

Enable it with:

```nix
{
  services.cliproxyapi.enable = true;
}
```

The service runs as a dedicated `cliproxyapi` user and keeps its configuration and OAuth tokens under `/var/lib/cliproxyapi`. The configuration file is regenerated from [](#opt-services.cliproxyapi.settings) at startup, which overwrites any changes made through the management API.

## Authentication {#module-services-cliproxyapi-authentication}

Provider logins use OAuth and must land in the service's `oauth.auth-dir` (`/var/lib/cliproxyapi`), which is owned by the `cliproxyapi` user. Either of the approaches below writes the token with the correct ownership, and the running service picks it up without a restart.

### Management API {#module-services-cliproxyapi-authentication-management-api}

Set a management key in [](#opt-services.cliproxyapi.settings):

```nix
{
  services.cliproxyapi.settings.management.secret-key._secret = "/run/secrets/cliproxyapi-mgmt-key";
}
```

Request a login URL and open it in a browser:

```bash
curl -H "Authorization: Bearer <management-key>" \
  "http://127.0.0.1:8317/v8/management/oauth/auth-url?provider=claude"
```

Other values for `provider` are `codex`, `antigravity`, `kimi`, `kimi-ai`, `xai`, `devin` and `meta`. `kimi`, `kimi-ai`, `xai` and `meta` use a device code, so the login finishes once it is approved in the browser.

For `claude`, `codex` and `antigravity`, the browser ends up on a `localhost` page that fails to load. Send that URL to the daemon to finish the login:

```bash
curl -H "Authorization: Bearer <management-key>" \
  -H "Content-Type: application/json" \
  -d '{"redirect_url": "<url>"}' \
  http://127.0.0.1:8317/v8/management/oauth/callback
```

Alternatively, add `is_webui=true` to the login URL request, and the daemon will listen on the callback port and finish the login itself.

To check on a login, query `/v8/management/oauth/status?state=<state>` with the `state` from the login URL response. It returns `wait` while the login is pending, `ok` once the token is saved and `error` if it failed.

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

Other providers have their own flags, such as `--codex-login` or `--xai-login`; see `cliproxyapi -help`. On a headless host, add `-no-browser` to print the login URL. The Claude, Codex, Antigravity and Devin logins then ask you to paste the `localhost` URL you were redirected to.
