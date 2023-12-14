{ stdenv, lib, fetchurl, fetchFromGitHub, jq, wofi, wtype, wl-clipboard }:

let emojiJSON = fetchurl {
  url = "https://raw.githubusercontent.com/muan/emojilib/v3.0.10/dist/emoji-en-US.json";
  hash = "sha256-UhAB5hVp5vV2d1FjIb2TBd2FJ6OPBbiP31HGAEDQFnA=";};
in
stdenv.mkDerivation rec {
  pname = "wofi-emoji";
  version = "unstable-2023-06-19";

  src = fetchFromGitHub {
    owner = "Zeioth";
    repo = pname;
    rev = "796d688b71ac9fa1e5b2c1b9a3fa11dba801b02b";
    hash = "sha256-HBsqekNuKqxaKaSeLboukLm4Lkg9JakPO7uN3Z8QBC8=";
  };

  nativeBuildInputs = [ jq ];
  buildInputs = [ wofi wtype wl-clipboard ];

  postPatch = ''
    substituteInPlace build.sh \
      --replace 'curl ${emojiJSON.url}' 'cat ${emojiJSON}'
  '';

  buildPhase = ''
    runHook preBuild

    bash build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp wofi-emoji $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple emoji selector for Wayland using wofi and wl-clipboard";
    homepage = "https://github.com/dln/wofi-emoji";
    license = licenses.mit;
    maintainers = [ maintainers.ymarkus ];
    platforms = platforms.all;
  };
}
