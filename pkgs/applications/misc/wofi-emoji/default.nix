{ stdenv, lib, fetchurl, fetchFromGitHub, jq, wofi, wtype, wl-clipboard }:

let emojiJSON = fetchurl {
  url = "https://raw.githubusercontent.com/muan/emojilib/v3.0.6/dist/emoji-en-US.json";
  sha256 = "sha256-wf7zsIEbX/diLwmVvnN2Goxh2V5D3Z6nbEMSb5pSGt0=";
};
in
stdenv.mkDerivation rec {
  pname = "wofi-emoji";
  version = "unstable-2022-08-19";

  src = fetchFromGitHub {
    owner = "dln";
    repo = pname;
    rev = "c5ecb4f0f164aedb046f52b5eacac889609c8522";
    sha256 = "1wq276bhf9x24ds13b2dwa69cjnr207p6977hr4bsnczryg609rh";
  };

  nativeBuildInputs = [ jq ];
  buildInputs = [ wofi wtype wl-clipboard ];

  postPatch = ''
    substituteInPlace build.sh \
      --replace 'curl ${emojiJSON.url}' 'cat emoji-en-US.json'
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
