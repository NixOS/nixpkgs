{
  fetchFromGitHub,
  gawk,
  lib,
  runCommand,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "goto";
  version = "2.1.0-unstable-2020-11-15";

  src = fetchFromGitHub {
    owner = "iridakos";
    repo = "goto";
    # no tags
    rev = "b7fda54e0817b9cb47e22a78bd00b4571011cf58";
    hash = "sha256-dUxim8LLb+J9cI7HySkmC2DIWbWAKSsH/cTVXmt8zRo=";
  };

  strictDeps = true;

  buildInputs = [ gawk ];

  postInstall = ''
    install -Dm644 goto.sh -t $out/share/
  '';

  passthru.tests.basic-usage =
    runCommand "goto-basic-usage"
      {
        nativeBuildInputs = [ writableTmpDirAsHomeHook ];
      }
      ''
        # Mock `complete` since the builder `pkgs.bash` is not interactive.
        complete() { return; }

        source ${finalAttrs.finalPackage}/share/goto.sh

        goto --register pwd .
        cd /
        goto pwd
        goto --unregister pwd
        goto --list

        touch $out
      '';

  meta = {
    description = "Alias and navigate to directories with tab completion";
    homepage = "https://github.com/iridakos/goto";
    changelog = "https://github.com/iridakos/goto/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.bmrips ];
  };
})
