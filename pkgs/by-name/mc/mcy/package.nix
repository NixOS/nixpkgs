{
  lib,
  stdenv,
  fetchFromGitHub,
  yosys,
  python3,
}:

let
  python = python3.withPackages (p: with p; [ flask ]);
in
stdenv.mkDerivation {
  pname = "mcy";
  version = "2020.08.03";

  src = fetchFromGitHub {
    owner = "YosysHQ";
    repo = "mcy";
    rev = "62048e69df13f8e03670424626755ae8ef4c36ff";
    sha256 = "15xxgzx1zxzx5kshqyrxnfx33cz6cjzxcdcn6z98jhs9bwyvf96f";
  };

  buildInputs = [ python ];
  patchPhase = ''
    chmod +x scripts/create_mutated.sh
    patchShebangs .

    substituteInPlace mcy.py \
      --replace yosys '${yosys}/bin/yosys' \
      --replace 'os.execvp("mcy-dash"' "os.execvp(\"$out/bin/mcy-dash\""
    substituteInPlace mcy-dash.py \
      --replace 'app.run(debug=True)' 'app.run(host="0.0.0.0",debug=True)' \
      --replace 'subprocess.Popen(["mcy"' "subprocess.Popen([\"$out/bin/mcy\""
    substituteInPlace scripts/create_mutated.sh \
      --replace yosys '${yosys}/bin/yosys'
  '';

  # the build needs a bit of work...
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin $out/share/mcy/{dash,scripts}
    install mcy.py      $out/bin/mcy      && chmod +x $out/bin/mcy
    install mcy-dash.py $out/bin/mcy-dash && chmod +x $out/bin/mcy-dash
    cp -r dash/.    $out/share/mcy/dash/.
    cp -r scripts/. $out/share/mcy/scripts/.
  '';

  meta = {
    description = "Mutation-based coverage testing for hardware designs, with Yosys";
    homepage = "https://github.com/YosysHQ/mcy";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.all;
  };
}
