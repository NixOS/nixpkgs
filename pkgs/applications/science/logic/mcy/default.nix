{ stdenv, fetchFromGitHub
, yosys, symbiyosys, python3
}:

let
  python = python3.withPackages (p: with p; [ flask ]);
in
stdenv.mkDerivation {
  pname = "mcy";
  version = "2020.02.05";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "mcy";
    rev    = "83deeddd12d583a89ad4aa1d2147efa4d6adc33c";
    sha256 = "1i0cabiqr68zflwzc6z894i4n7k6m3hbfck58vzh8zb9jwxwizav";
  };

  buildInputs = [ python ];
  patchPhase = ''
    substituteInPlace mcy.py \
      --replace yosys '${yosys}/bin/yosys' \
      --replace 'os.execvp("mcy-dash"' "os.execvp(\"$out/libexec/mcy/mcy-dash.py\""
  '';

  # the build needs a bit of work...
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin $out/libexec/mcy
    install mcy.py $out/bin/mcy && chmod +x $out/bin/mcy
    install mcy-dash.py $out/libexec/mcy/mcy-dash.py
  '';

  meta = {
    description = "Mutation-based coverage testing for hardware designs, with Yosys";
    homepage    = "https://github.com/YosysHQ/mcy";
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.all;
  };
}
