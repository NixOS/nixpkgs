{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dstask";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "naggie";
    repo = "dstask";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/SXQz+HDkKWGrIArqEjti93mo6Els9haitV0FfWfVTQ=";
  };

  # Set vendorHash to "sha256-HSqAbxkkjuMulFymeqApWr/JZ+a7OUTu5EYLGPL/j2U=" because dstask vendors its dependencies (meaning
  # that third party dependencies are stored in the repository).
  #
  # Ref <https://github.com/NixOS/nixpkgs/pull/87383#issuecomment-633204382>
  # and <https://github.com/NixOS/nixpkgs/blob/d4226e3a4b5fcf988027147164e86665d382bbfa/pkgs/development/go-modules/generic/default.nix#L18>
  vendorHash = "sha256-HSqAbxkkjuMulFymeqApWr/JZ+a7OUTu5EYLGPL/j2U=";

  doCheck = false;

  # The ldflags reduce the executable size by stripping some debug stuff.
  # The other variables are set so that the output of dstask version shows the
  # git ref and the release version from github.
  # Ref <https://github.com/NixOS/nixpkgs/pull/87383#discussion_r432097657>
  ldflags = [
    "-w"
    "-s"
    "-X github.com/naggie/dstask.VERSION=${finalAttrs.version}"
    "-X github.com/naggie/dstask.GIT_COMMIT=v${finalAttrs.version}"
  ];

  meta = {
    description = "Command line todo list with super-reliable git sync";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stianlagstad ];
    platforms = lib.platforms.linux;
  };
})
