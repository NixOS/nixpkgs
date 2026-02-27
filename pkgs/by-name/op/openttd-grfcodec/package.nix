{
  stdenv,
  lib,
  fetchFromGitHub,
  boost,
  cmake,
  git,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openttd-grfcodec";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "OpenTTD";
    repo = "grfcodec";
    tag = finalAttrs.version;
    hash = "sha256-zIRHo2glD738Rmg4dhetIGtbIY/AgMKnzAJaP00lsqk=";
    leaveDotGit = true;
    postFetch = ''
      # git arguments taken from generate_version.cmake
      git_date=$(git -C $out show -s --pretty=%cd --date=short)
      echo "${finalAttrs.version};$git_date" > $out/.version
      rm -rf $out/.git
    '';
  };

  buildInputs = [ boost ];

  nativeBuildInputs = [
    cmake
    git
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/grfcodec";

  installPhase = ''
    mkdir -p $out/bin
    cp -a grfcodec grfid grfstrip nforenum $out/bin/
  '';

  meta = {
    description = "Low-level (dis)assembler and linter for OpenTTD GRF files";
    homepage = "http://openttd.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ToxicFrog ];
  };
})
