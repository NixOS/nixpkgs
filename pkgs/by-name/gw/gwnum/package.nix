{
  stdenv,
  lib,
  fetchurl,
  unzip,
  gmp,
  version ? "31.04b02",
  hash ? "sha256-9raQlbY7CRybXQA/GBUK4Pat6mlzUV8+o9m7ErP/Tr0=",
}:

let
  versionMatch = builtins.match "([0-9]+)\\.([0-9]+)[.b]([0-9]+)" version;
  major =
    if versionMatch != null then
      lib.elemAt versionMatch 0
    else
      throw "Invalid version format: ${version}";
  rawMinor = lib.elemAt versionMatch 1;
  rawPatch = lib.elemAt versionMatch 2;
in
stdenv.mkDerivation {
  pname = "gwnum";
  inherit version;

  src = fetchurl {
    urls = [
      "https://download.mersenne.ca/gimps/v${major}/${major}.${rawMinor}/p95v${major}${rawMinor}b${rawPatch}.source.zip"
      "https://download.mersenne.ca/gimps/v${major}/_pre-release/${major}.${rawMinor}/p95v${major}${rawMinor}b${rawPatch}.source.zip"
    ];
    inherit hash;
  };

  nativeBuildInputs = [ unzip ];
  buildInputs = [ gmp ];

  sourceRoot = "gwnum";
  makefile = "make64";

  passthru.updateScript = ./update.sh;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/include
    cp gwnum.a $out/lib/libgwnum.a
    cp *.h $out/include/

    runHook postInstall
  '';

  meta = with lib; {
    description = "High-performance library for modular arithmetic on very large numbers";
    longDescription = ''
      The gwnum library is a high-performance modular arithmetic library specifically optimized for Intel processors. It enables extremely fast multiplication, addition, and subtraction on very large numbers (up to 1.1 billion bits) by utilizing highly optimized Fast Fourier Transforms (FFTs) and core routines written in Intel assembly code. While it is a general-purpose library for large-number modular arithmetic, it is primarily known for its use in the Great Internet Mersenne Prime Search (GIMPS) and the Prime95/MPrime software, where it provides the heavy-lifting for primality testing on numbers of the form k*b^n+c.
    '';
    homepage = "https://www.mersenne.org/";
    # Unfree, because of a license requirement to share prize money if you find
    # a suitable Mersenne prime using the library. http://www.mersenne.org/legal/#EULA
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ brubsby ];
  };
}
