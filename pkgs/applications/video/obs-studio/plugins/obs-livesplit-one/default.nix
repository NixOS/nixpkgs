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

  cargoHash = "sha256-mQ0TR4DL4bA5u4IL3RY9aLxU5G6qQ5W5xuNadiXGeB0=";

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
