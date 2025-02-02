{
  lib,
  fetchFromGitHub,
  python3,
  rsync,
  nix-update-script,
}:
python3.pkgs.buildPythonApplication rec {
  name = "ietf-cli";
  version = "1.29";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "paulehoffman";
    repo = "ietf-cli";
    tag = version;
    hash = "sha256-xpwUUyTq/8WOUjssNkXOvxBYPgL7pmVVPz6abKetVc8=";
  };
  buildInputs = [ rsync ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ./ietf -t $out/bin

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line interface for accessing IETF documents and other information";
    mainProgram = "ietf";
    homepage = "https://github.com/paulehoffman/ietf-cli";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ lilioid ];
    platforms = lib.lists.intersectLists python3.meta.platforms rsync.meta.platforms;
  };
}
