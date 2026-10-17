{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  openssl,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cfait";
  version = "1.2.0";

  src = fetchFromGitea {
    domain = "git.disroot.org";
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AB9bGo+C7ySM0EodoHLxpcxKPEK6ytFaiWgnXLi5FSg=";
  };

  cargoHash = "sha256-pSXujSOdK51LjT3MaVXR1V7FmrJs2o3O5y/mZmAXxag=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  meta = {
    description = "Fast, offline-first CalDAV and local task manager";
    homepage = "https://git.disroot.org/trougnouf/cfait";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ JorySeverijnse ];
    mainProgram = "cfait";
  };
})
