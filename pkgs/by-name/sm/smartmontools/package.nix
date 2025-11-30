{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  enableMail ? false,
  gnused,
  hostname,
  mailutils,
  systemdLibs,
}:

let
  dbrev = "5714";
  drivedbBranch = "RELEASE_7_5_DRIVEDB";
  driverdb = fetchurl {
    url = "https://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
    sha256 = "sha256-DndzUHpZex3F9WXYq+kNDWvkLNc1OZX3KR0mby5cKbA=";
    name = "smartmontools-drivedb.h";
  };
  scriptPath = lib.makeBinPath (
    [
      gnused
      hostname
    ]
    ++ lib.optionals enableMail [ mailutils ]
  );

in
stdenv.mkDerivation rec {
  pname = "smartmontools";
  version = "7.5";

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${pname}-${version}.tar.gz";
    hash = "sha256-aQuDyjMTeNqeoNnWEAjEsi3eOROHubutfyk4fyWV924=";
  };

  patches = [
    # fixes darwin build
    ./smartmontools.patch
  ];
  postPatch = ''
    cp -v ${driverdb} drivedb.h
  '';

  configureFlags = [
    "--with-scriptpath=${scriptPath}"
    # does not work on NixOS
    "--without-update-smart-drivedb"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals (lib.meta.availableOn stdenv.hostPlatform systemdLibs) [ systemdLibs ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage = "https://www.smartmontools.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ Frostman ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "smartctl";
  };
}
