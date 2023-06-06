{ lib
, fetchFromGitHub
, rustPlatform
, cmake
, fontconfig
, obs-studio
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-livesplit-one";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "CryZe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-C1u4z7iQUETM84kf6S6obw+C0ox8J9gMJoVP3/3ZoYw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "livesplit-core-0.11.0" = "sha256-efap498JWOeGBg3A/7BMME/6GyvuTli9hegxS+jeruQ=";
    };
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fontconfig obs-studio ];

  postInstall = ''
    mkdir $out/lib/obs-plugins/
    mv $out/lib/libobs_livesplit_one.so $out/lib/obs-plugins/obs-livesplit-one.so
  '';

  meta = with lib; {
    description = "OBS Studio plugin for adding LiveSplit One as a source";
    homepage = "https://github.com/CryZe/obs-livesplit-one";
    license = with licenses; [ asl20 mit ];
    maintainers = [ maintainers.Bauke ];
    platforms = obs-studio.meta.platforms;
  };
}
