{
  lib,
  stdenv,
  fetchFromGitHub,
  premake5,
}:

stdenv.mkDerivation rec {
  pname = "otfcc";
  version = "0.10.4";

  # archived by the owner on Jun 3, 2022. No viable forks.
  src = fetchFromGitHub {
    owner = "caryll";
    repo = "otfcc";
    rev = "v${version}";
    sha256 = "1nrkzpqklfpqsccji4ans40rj88l80cv7dpxwx4g577xrvk13a0f";
  };

  nativeBuildInputs = [ premake5 ];

  patches = [
    ./fix-aarch64.patch
    ./move-makefiles.patch
  ];

  buildFlags = lib.optionals stdenv.hostPlatform.isAarch64 [ "config=release_arm" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release-*/otfcc* $out/bin/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Optimized OpenType builder and inspector";
    homepage = "https://github.com/caryll/otfcc";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel ];
    # Build fails on all platforms with
    #        > configure flags: gmake
    #   > ** Warning: action 'xcode4' sets 'os' field, which is deprecated, use 'targetos' instead.
    #   > Error: invalid value 'StaticRuntime' for flags
    broken = true;
  };

}
