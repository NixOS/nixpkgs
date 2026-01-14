{
  fetchFromGitHub,
  rustPlatform,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "disktui";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "Maciejonos";
    repo = "disktui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FDpdOpyvdU2Uw22am/Vkdls+s6ZdmodNt3WAQd8L53I=";
  };
  cargoHash = "sha256-CBSd/zeThyhmsaKx8Pg+u14QEQVq5nPLcRKet9n8WC8=";

  meta = {
    description = "TUI for disk management on Linux";
    homepage = "https://github.com/Maciejonos/disktui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Inarizxc ];
    platforms = lib.platforms.linux;
    mainProgram = "disktui";
  };
})
