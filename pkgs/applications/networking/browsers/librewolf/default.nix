{ stdenv
  , lib
  , callPackage
  , buildMozillaMach
  , fetchurl
  , nixosTests
  , undmg
}:

let
  librewolf-src = callPackage ./librewolf.nix { };
  pname = "librewolf";
  meta = {
    description = "A fork of Firefox, focused on privacy, security and freedom";
    homepage = "https://librewolf.net/";
    maintainers = with lib.maintainers; [ squalus ];
    platforms = lib.platforms.unix;
    broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                          # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
    maxSilent = 14400; # 4h, double the default of 7200s (c.f. #129212, #129115)
    license = lib.licenses.mpl20;
  };
  updateScript = callPackage ./update.nix {
    attrPath = "librewolf-unwrapped";
  };
in
if
  stdenv.isDarwin
then
  stdenv.mkDerivation {
    inherit pname;
    version = librewolf-src.packageVersion;
    src =
      let
        bin = with librewolf-src.bin.mac; if stdenv.isAarch64 then aarch64 else x86_64;
      in
        fetchurl { inherit (bin) url sha256; };
    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";
    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
    inherit meta;
    passthru = {
      inherit updateScript;
    };
  }
else
  ((buildMozillaMach rec {
    inherit pname;
    applicationName = "LibreWolf";
    binaryName = "librewolf";
    version = librewolf-src.packageVersion;
    src = librewolf-src.firefox;
    inherit (librewolf-src) extraConfigureFlags extraPatches extraPostPatch extraPassthru;

    inherit meta;
    tests = [ nixosTests.librewolf ];
    inherit updateScript;
  }).override {
    crashreporterSupport = false;
    enableOfficialBranding = false;
  }).overrideAttrs (prev: {
    MOZ_REQUIRE_SIGNING = "";
  })
