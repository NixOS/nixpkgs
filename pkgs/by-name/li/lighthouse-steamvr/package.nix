{
  fetchFromGitHub,
  lib,
  rustPlatform,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "Lighthouse";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = finalAttrs.version;
    hash = "sha256-2AJMXnfMvtYfCWusVDdZYUzKIPxey2mP4v3JVhsp2JE=";
  };

  cargoHash = "sha256-fOiVMg3K3wYhgYZ9kx3WfAgrgcSzUKjKyvXm5N386nw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  meta = {
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bddvlpr ];
    mainProgram = "lighthouse";
  };
})
