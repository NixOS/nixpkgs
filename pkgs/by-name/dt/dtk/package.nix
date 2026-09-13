{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  perl,
}:
stdenvNoCC.mkDerivation {
  pname = "dtk";
  version = "0-unstable-2020-05-28";

  src = fetchFromGitHub {
    owner = "synacor";
    repo = "dtk";
    rev = "8d0e8707762bf36181db506da383cf4b44fa074a";
    hash = "sha256-pzYsz2oJRZMA+81h8j+poBkTmkTVVFanwLG3Ll0RcVQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    (perl.withPackages (ps: [ ps.TimeDate ]))
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 dtk $out/bin/dtk

    mkdir -p $out/libexec/dtk-modules/parse-formats
    for f in modules/*; do
      [ -f "$f" ] && install -m755 "$f" $out/libexec/dtk-modules/
    done
    for f in modules/parse-formats/*; do
      [ -f "$f" ] && install -m755 "$f" $out/libexec/dtk-modules/parse-formats/
    done

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/dtk \
      --prefix DTK_MODPATH : $out/libexec/dtk-modules
    for f in $out/libexec/dtk-modules/*; do
      [ -f "$f" ] && wrapProgram "$f"
    done
    for f in $out/libexec/dtk-modules/parse-formats/*; do
      [ -f "$f" ] && wrapProgram "$f"
    done
  '';

  meta = {
    description = "Suite of command-line tools for parsing, analyzing, and visualizing logs and datasets";
    homepage = "https://github.com/synacor/dtk";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "dtk";
    maintainers = with lib.maintainers; [ Aneurysm9 ];
  };
}
