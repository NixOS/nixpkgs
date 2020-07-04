{ stdenv, fetchFromGitHub
, yosys, symbiyosys, python3
}:

let
  python = python3.withPackages (p: with p; [ flask ]);
in
stdenv.mkDerivation {
  pname = "mcy";
  version = "2020.03.21";

  src = fetchFromGitHub {
    owner  = "YosysHQ";
    repo   = "mcy";
    rev    = "bac92b8aad9bf24714fda70d3750bb50d6d96177";
    sha256 = "0mmg6zd5cbn8g0am9c3naamg0lq67yyy117fzn2ydigcyia7vmnp";
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
