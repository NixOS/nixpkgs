{ stdenv, lib, fetchurl, fetchFromGitHub, jq, wofi, wtype, wl-clipboard }:

let emojiJSON = fetchurl {
  url = "https://raw.githubusercontent.com/muan/emojilib/v3.0.10/dist/emoji-en-US.json";
  hash = "sha256-UhAB5hVp5vV2d1FjIb2TBd2FJ6OPBbiP31HGAEDQFnA=";};
in
stdenv.mkDerivation rec {
  pname = "wofi-emoji";
  version = "unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "Zeioth";
    repo = pname;
    rev = "2cc95880848134a3bbe0675bcb62a0dae1d0f572";
    hash = "sha256-t9M8z8JxuvBDzNs98L7YTNUfTK23W1DYGdHDiXNQOgk=";
  };

  nativeBuildInputs = [ jq ];
  buildInputs = [ wofi wtype wl-clipboard ];

  postPatch = ''
    substituteInPlace build.sh \
      --replace 'curl ${emojiJSON.url}' 'cat ${emojiJSON}'
    substituteInPlace wofi-emoji \
      --replace 'wofi' '${wofi}/bin/wofi' \
      --replace 'wtype' '${wtype}/bin/wtype' \
      --replace 'wl-copy' '${wl-clipboard}/bin/wl-copy'
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
