{
  stdenv,
  lib,
  fetchFromForgejo,
  zig_0_15,
  callPackage,
  optimizeLevel ? "ReleaseFast",
}:
stdenv.mkDerivation rec {
  pname = "nixie";
  version = "05.03.26";

  src = fetchFromForgejo {
    domain = "forge.starlightnet.work";
    owner = "Team";
    repo = "nixie";
    rev = version;
    hash = "sha256-mRY07lnCoDb6uDlNn0cVR+AkIyuuWcoLdwIkJSiBcrE=";
  };

  deps = callPackage ./deps.nix {
    name = "${pname}-cache-${version}";
  };

  strictDeps = true;

  dontSetZigDefaultFlags = true;

  zigBuildFlags = [
    "--system"
    "${deps}"
    "-Doptimize=${optimizeLevel}"
  ];

  nativeBuildInputs = [
    zig_0_15
  ];

  meta = {
    description = "A self-hostable, privacy friendly, and cool looking counter button for the countercultures";
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
