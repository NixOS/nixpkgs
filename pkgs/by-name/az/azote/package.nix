{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  libappindicator-gtk3,
  nix-update-script,
  python3,
  python3Packages,
  wrapGAppsHook3,

  # runtime
  bash,
  findutils,
  gawk,
  imagemagick,
  procps,

  # wayland
  waylandSupport ? true,
  sway,
  swaybg,
  wlr-randr,
  grim,
  slurp,

  # x11
  x11Support ? true,
  feh,
  maim,
  slop,
  xorg,
}:
python3Packages.buildPythonApplication rec {
  pname = "azote";
  version = "1.12.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "azote";
    rev = "v${version}";
    hash = "sha256-ffymC1pxR6v6Qn0n9W3vENh4IGHZk1WNQog+ohuNI68=";
  };

  nativeBuildInputs = [
    gobject-introspection
    python3.pkgs.setuptools
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libappindicator-gtk3
  ];

  postPatch =
    # FIXME: not replacing full lines due to escaping issues
    lib.optionalString waylandSupport ''
      substituteInPlace ./azote/main.py \
        --replace-fail \
          "batch_content = ['#!/usr/bin/env bash', 'pkill swaybg']" \
          "batch_content = ['#!/usr/bin/env bash', '${lib.getExe' procps "pkill"} swaybg']" \
        --replace-fail \
          "swaybg -o" \
          "${lib.getExe swaybg} -o"
    ''
    + lib.optionalString x11Support ''
      substituteInPlace ./azote/main.py \
        --replace-fail \
          "command = \"feh --bg-{}\".format(mode)" \
          "command = \"${lib.getExe feh} --bg-{}\".format(mode)"
    '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : ${
        python3.pkgs.makePythonPath (
          with python3.pkgs;
          [
            pygobject3
            pillow
            send2trash
          ]
        )
      } \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            bash
            findutils
            gawk
            imagemagick
            procps
          ]
          ++ lib.optionals waylandSupport [
            sway
            swaybg
            wlr-randr
            grim
            slurp
          ]
          ++ lib.optionals x11Support [
            feh
            maim
            slop
            xorg.xrandr
          ]
        )
      }"
    )
  '';

  pythonImportsCheck = [ "azote" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wallpaper manager for wlroots-based compositors and some other WMs";
    homepage = "https://github.com/nwg-piotr/azote";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Guanran928 ];
    mainProgram = "azote";
  };
}
