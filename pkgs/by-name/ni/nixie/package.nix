{
  stdenv,
  lib,
  fetchFromForgejo,
  zig_0_15,
  callPackage,
}:
stdenv.mkDerivation rec {
  pname = "nixie";
  version = "05.03.26";

  src = fetchFromForgejo {
    domain = "forge.starlightnet.work";
    owner = "Team";
    repo = "nixie";
    tag = version;
    hash = "sha256-mRY07lnCoDb6uDlNn0cVR+AkIyuuWcoLdwIkJSiBcrE=";
  };

  deps = callPackage ./deps.nix {
    name = "${pname}-cache-${version}";
  };

  zigBuildFlags = [
    "--system"
    "${deps}"
  ];

  nativeBuildInputs = [
    zig_0_15
  ];

  meta = {
    description = "Self-hostable, privacy friendly, and cool looking counter button for the countercultures";
    longDescription = ''
      nixie is a simple yet effective,self-hostable view counter for your cool websites, it was engineered to be ridiculously lightweight, highly concurrent, and privacy focused.
    '';
    homepage = "https://nixie.starlightnet.work/";
    license = lib.licenses.zlib;
    mainProgram = "nixie";
    maintainers = [
      lib.maintainers.twoneis
    ];
    platforms = lib.platforms.linux;
  };
}
