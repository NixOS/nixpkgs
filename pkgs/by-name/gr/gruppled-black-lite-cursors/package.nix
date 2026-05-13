{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  theme ? "black",
}:

assert lib.asserts.assertOneOf "theme" theme [
  "black"
  "white"
];

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gruppled-${theme}-lite-cursors";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "gruppled-lite-cursors";
    rev = "v${finalAttrs.version}";
    hash = "sha256-adCXYu8v6mFKXubVQb/RCZXS87//YgixQp20kMt7KT8=";
  };

  installPhase = ''
    mkdir -p $out/share/icons/gruppled_${theme}_lite
    cp -r gruppled_${theme}_lite/{cursors,index.theme} $out/share/icons/gruppled_${theme}_lite
  '';

  meta = {
    description = "Gruppled ${lib.toSentenceCase theme} Lite Cursors theme";
    homepage = "https://github.com/nim65s/gruppled-lite-cursors";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
