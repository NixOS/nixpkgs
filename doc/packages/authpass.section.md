# AuthPass {#sec-authpass}

By default, the proprietary cloud storage integrations (Dropbox, Google Drive,
OneDrive) are disabled, because upstream does not publish the OAuth
application credentials used in its official binaries. Local files, WebDAV and
AuthPass Cloud work without any configuration.

To enable e.g. Dropbox, register your own application with the respective
service and pass its credentials to the build:

```nix
(authpass.override {
  dropboxKey = "your-app-key";
  dropboxSecret = "your-app-secret";
})
```

The corresponding arguments for Google Drive are `googleClientId` and
`googleClientSecret`, and for OneDrive `microsoftClientId` and
`microsoftClientSecret`.

For Dropbox, the registered application needs the `account_info.read`,
`files.metadata.read`, `files.metadata.write`, `files.content.read` and
`files.content.write` permission scopes. Enable them in the Dropbox App
Console *before* connecting the account: scopes are baked into the access
token at authorization time, so an account connected earlier keeps its
scope-less token (API calls fail with `400 Bad Request`) — remove the
account in AuthPass and authorize again after changing the scopes.

Note that the credentials become part of the store path and the compiled
binary. This is acceptable for OAuth application credentials (they identify
the application, not a user account), but do not pass any personal secrets.
