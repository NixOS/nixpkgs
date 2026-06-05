{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  imgui,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imgui-file-dialog";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "aiekick";
    repo = "ImGuiFileDialog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v5ROW4o4of3tUGMN/p/CNH1eWT+RNRlWvhI84HUMEGo=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ imgui ];

  # Propagate imgui so users can find the headers (ImGuiFileDialog.h includes imgui.h)
  propagatedBuildInputs = [ imgui ];

  outputs = [
    "out"
    "dev"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full featured file dialog for Dear ImGui";
    homepage = "https://github.com/aiekick/ImGuiFileDialog";
    changelog = "https://github.com/aiekick/ImGuiFileDialog/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ZZBaron ];
    platforms = lib.platforms.all;
  };
})
