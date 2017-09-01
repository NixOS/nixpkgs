{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

let
  rev = "ab1c44b49657e856ab7e03e6c80c6972206504da";
in
buildRustPackage rec {
  name = "svgbob";
  name = "svgbobrus";
  version = "29-08-2017";

  src = fetchFromGitHub {
    owner = "ivanceras";
    repo = "svgbobrus";
    inherit rev;
    sha256 = "1bbh6inrif2y8159j4y1nvnrcf3fscrhb3zrshfms4847pms42cs";
  };

  depsSha256 = "1zd1wbx8ix4722r5j2w8293h90s0lyp1ia8ax9198ilpivbhm5ns";

  sourceRoot = "${name}-${rev}-src/svgbob_cli";

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = https://github.com/ivanceras/svgbobrus;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}

