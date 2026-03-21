{
  stdenv,
  lib,
  fetchFromGitea,
  cmake,
  ninja,
  tzdata,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tzdb_to_nx";
  version = "120226";

  src = fetchFromGitea {
    domain = "git.crueter.xyz";
    owner = "misc";
    repo = "tzdb_to_nx";
    tag = finalAttrs.version;
    hash = "sha256-egPu8UVbj73RQ0Z5JMTjd5HVdy47WTfkUMlQaS0wUTg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  cmakeFlags = [
    (lib.cmakeFeature "TZDB2NX_ZONEINFO_DIR" "${tzdata}/share/zoneinfo")
    (lib.cmakeFeature "TZDB2NX_VERSION" tzdata.version)
  ];

  ninjaFlags = [ "x80e" ];

  installPhase = ''
    runHook preInstall

    cp -r src/tzdb/nx $out

    runHook postInstall
  '';

  meta = {
    description = "RFC 8536 time zone data converted to the Nintendo Switch format";
    homepage = "https://git.crueter.xyz/misc/tzdb_to_nx";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    license = with lib.licenses; [
      # Converter
      mit

      # Data
      publicDomain
    ];
    platforms = lib.platforms.all;
  };
})
