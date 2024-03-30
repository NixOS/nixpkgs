{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "daisyui";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "saadeghi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rHu3jQS7wDBFa3dF7vPmmXyZD6ytc+rXh4SZ294jZpc=";
  };

  npmDepsHash = "sha256-BwtK65DlHFaIxYpY64iGVwvM3lPtOFVxS9BHRoKsMmg=";

  # use generated package-lock.json as upstream does not provide one
  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "A free and open-source Tailwind CSS component library";
    homepage = "https://daisyui.com/";
    license = licenses.mit;
    maintainers = [ maintainers.osmano807 ];
  };
}
