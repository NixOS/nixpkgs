{ stdenv
, lib
, fetchFromGitHub
, cmake

# Dependencies
, clipper
, libarcus
, protobuf
, rapidjson
, stb
}:

stdenv.mkDerivation rec {
  pname = "curaengine";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "Ultimaker";
    repo = "CuraEngine";
    # TODO: Switch back to `rev = version;` on the next release that has this fix:
    #       https://github.com/Ultimaker/CuraEngine/commit/bb9ad578abc949c474db7a0677a355ad379ae585#diff-1e7de1ae2d059d21e1dd75d5812d5a34b0222cef273b7c3a2af62eb747f9d20aL262
    #       for https://github.com/Ultimaker/CuraEngine/issues/1650
    rev = "41989f284a7350b9d70b0ae2d4e53b6a16adf9c9";
    sha256 = "10kmv388mhgy4sl0jrb4x8ypm00176mxvzbf5b6z6639xzr98jnk";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    clipper
    libarcus
    protobuf
    rapidjson
    stb
  ];

  cmakeFlags = [ "-DCURA_ENGINE_VERSION=${version}" ];

  meta = with lib; {
    description = "A powerful, fast and robust engine for processing 3D models into 3D printing instruction";
    homepage = "https://github.com/Ultimaker/CuraEngine";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar gebner ];
  };
}
