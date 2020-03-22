{ stdenv, fetchFromGitHub
, yosys, symbiyosys, python3
}:

let
  python = python3.withPackages (p: with p; [ flask ]);
in
stdenv.mkDerivation {
  pname = "mcy";
  version = "2020.03.16";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "mcy";
    rev    = "562c02375067428bb657f57faa5131ee1ab44051";
    sha256 = "0q77v2hxnmv61zx5bl4lrqiavgvsiyb5qxdp9hnihimj1m30bc5h";
  };

  buildInputs = [ python ];
  patchPhase = ''
    substituteInPlace mcy.py \
      --replace yosys '${yosys}/bin/yosys' \
      --replace 'os.execvp("mcy-dash"' "os.execvp(\"$out/bin/mcy-dash\""
    substituteInPlace mcy-dash.py \
      --replace 'app.run(debug=True)' 'app.run(host="0.0.0.0",debug=True)'
  '';

  # the build needs a bit of work...
  buildPhase = "true";
  installPhase = ''
    mkdir -p $out/bin $out/share/mcy/dash
    install mcy.py      $out/bin/mcy      && chmod +x $out/bin/mcy
    install mcy-dash.py $out/bin/mcy-dash && chmod +x $out/bin/mcy-dash
    cp -r dash/. $out/share/mcy/dash/.
  '';

  meta = {
    description = "Mutation-based coverage testing for hardware designs, with Yosys";
    homepage    = "https://github.com/YosysHQ/mcy";
    license     = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.all;
  };
}
