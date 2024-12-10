{
  lib,
  melpaBuild,
  fetchFromGitHub,
  acm,
  popon,
  writeText,
  writeScript,
}:

let
  rev = "1851d8fa2a27d3fd8deeeb29cd21c3002b8351ba";
in
melpaBuild {
  pname = "acm-terminal";
  version = "20231206.1141";

  src = fetchFromGitHub {
    owner = "twlz0ne";
    repo = "acm-terminal";
    inherit rev;
    sha256 = "sha256-EYhFrOo0j0JSNTdcZCbyM0iLxaymUXi1u6jZy8lTOaY=";
  };

  commit = rev;

  packageRequires = [
    acm
    popon
  ];

  recipe = writeText "recipe" ''
    (acm-terminal :repo "twlz0ne/acm-terminal" :fetcher github)
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts coreutils git gnused
    set -eu -o pipefail
    tmpdir="$(mktemp -d)"
    git clone --depth=1 https://github.com/twlz0ne/acm-terminal.git "$tmpdir"
    pushd "$tmpdir"
    commit=$(git show -s --pretty='format:%H')
    # Based on: https://github.com/melpa/melpa/blob/2d8716906a0c9e18d6c979d8450bf1d15dd785eb/package-build/package-build.el#L523-L533
    version=$(TZ=UTC git show -s --pretty='format:%cd' --date='format-local:%Y%m%d.%H%M' | sed 's|\.0*|.|')
    popd
    update-source-version emacsPackages.acm-terminal $version --rev="$commit"
  '';

  meta = with lib; {
    description = "Patch for LSP bridge acm on Terminal";
    homepage = "https://github.com/twlz0ne/acm-terminal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
