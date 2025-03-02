{ bash
, coreutils
, curl
, fetchFromGitHub
, gnugrep
, gnused
, iproute2
, jq
, lib
, resholve
, wireguard-tools
}:

resholve.mkDerivation rec {
  pname = "wgnord";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "phirecc";
    repo = pname;
    rev = version;
    hash = "sha256-26cfYXtZVQ7kIRxY6oNGCqIjdw/hjwXhVKimVgolLgk=";
  };

  postPatch = ''
    substituteInPlace wgnord \
      --replace '$conf_dir/countries.txt' "$out/share/countries.txt" \
      --replace '$conf_dir/countries_iso31662.txt' "$out/share/countries_iso31662.txt"
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm 755 wgnord -t $out/bin/
    install -Dm 644 countries.txt -t $out/share/
    install -Dm 644 countries_iso31662.txt -t $out/share/
  '';

  solutions.default = {
    scripts = [ "bin/wgnord" ];
    interpreter = "${bash}/bin/sh";
    inputs = [
      coreutils
      curl
      gnugrep
      gnused
      iproute2
      jq
      wireguard-tools
    ];
    fix.aliases = true; # curl command in an alias
    execer = [
      "cannot:${iproute2}/bin/ip"
      "cannot:${wireguard-tools}/bin/wg-quick"
    ];
  };

  meta = with lib; {
    description = "NordVPN Wireguard (NordLynx) client in POSIX shell";
    homepage = "https://github.com/phirecc/wgnord";
    changelog = "https://github.com/phirecc/wgnord/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ urandom ];
    license = licenses.mit;
    mainProgram = "wgnord";
    platforms = platforms.linux;
  };
}
