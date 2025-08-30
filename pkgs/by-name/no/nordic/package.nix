{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk-engine-murrine,
  jdupes,
  kdePackages,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nordic";
  version = "2.2.0-unstable-2025-05-05";

  srcs = [
    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic";
      rev = "d9b5c42cebf9a165bcce7b6b8a019f5cfd5b789c";
      hash = "sha256-OkXjwaoXyWfTgNkeU+ab+uv+U/5OaJ8oTt/G8YLz84o=";
      name = "Nordic";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic";
      rev = "361f0d1d23177a1154d415f793ce52a2c09629d4";
      hash = "sha256-0IBuCMbHxTL3YtIK35g9xiBEs1DZgA4MwMAVPIw3Omk=";
      name = "Nordic-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic";
      rev = "bf05d41c7c7cd03e391854739bcc843fc6053ced";
      hash = "sha256-AjVvciUrm/X3U6Pmo52ZrucLRJdsRFPeEMRwSKyjwi4=";
      name = "Nordic-darker";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic";
      rev = "98cdf88d77fa7f0535ff660148e0ccbabe47a579";
      hash = "sha256-70l5+renDhniZroPoMrCHsPgT6Pg3cr5w86LjkaWchg=";
      name = "Nordic-darker-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic";
      rev = "f1e43cf9ba83602f73f71407a8a4ba768122b7f4";
      hash = "sha256-yLE/M9PXfQv2JD+HTsBHFiFaKuY8vOkZiOlQLLON+HM=";
      name = "Nordic-bluish-accent";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic";
      rev = "52a37ebce50f948129507e4804240d9e7788a7a2";
      hash = "sha256-zwnCaS08vceHjFHn9ET2509Zat7a1gHEG1RDR+xrbhc=";
      name = "Nordic-bluish-accent-standard-buttons";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic-polar";
      rev = "24dc0325c4a38508039f5fee9a5391c1d9d8d5d5";
      hash = "sha256-Y3PFuIc7UPbRg9NZie4buKCUiMXzl5idg7LSrj/lsos=";
      name = "Nordic-Polar";
    })

    (fetchFromGitHub {
      owner = "EliverLara";
      repo = "nordic-polar";
      rev = "fe0d657613a1e6330fa8c41378c324af93a42c3a";
      hash = "sha256-fusSDXawWttXWQfGloRkpkHWvfLPuljm1l0BpAKvNSg=";
      name = "Nordic-Polar-standard-buttons";
    })
  ];

  sourceRoot = ".";

  outputs = [
    "out"
    "sddm"
  ];

  nativeBuildInputs = [ jdupes ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    # install theme files
    mkdir -p $out/share/themes
    cp -a Nordic* $out/share/themes

    # remove uneeded files
    rm -r $out/share/themes/*/.gitignore
    rm -r $out/share/themes/*/Art
    rm -r $out/share/themes/*/FUNDING.yml
    rm -r $out/share/themes/*/LICENSE
    rm -r $out/share/themes/*/README.md
    rm -r $out/share/themes/*/{package.json,package-lock.json,Gulpfile.js}
    rm -r $out/share/themes/*/src
    rm -r $out/share/themes/*/cinnamon/*.scss
    rm -r $out/share/themes/*/gnome-shell/{earlier-versions,extensions,*.scss}
    rm -r $out/share/themes/*/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
    rm -r $out/share/themes/*/gtk-3.0/{apps,widgets,*.scss}
    rm -r $out/share/themes/*/gtk-4.0/{apps,widgets,*.scss}
    rm -r $out/share/themes/*/xfwm4/{assets,render_assets.fish}

    # move wallpapers to appropriate directory
    mkdir -p $out/share/wallpapers/Nordic
    mv -v $out/share/themes/Nordic/extras/wallpapers/* $out/share/wallpapers/Nordic/
    rmdir $out/share/themes/Nordic/extras{/wallpapers,}

    # move kde related contents to appropriate directories
    mkdir -p $out/share/{aurorae/themes,color-schemes,Kvantum,plasma,icons}
    mv -v $out/share/themes/Nordic/kde/aurorae/* $out/share/aurorae/themes/
    mv -v $out/share/themes/Nordic/kde/colorschemes/* $out/share/color-schemes/
    mv -v $out/share/themes/Nordic/kde/konsole $out/share/
    mv -v $out/share/themes/Nordic/kde/kvantum/* $out/share/Kvantum/
    cp -vr $out/share/themes/Nordic/kde/plasma/look-and-feel $out/share/plasma/look-and-feel/
    mv -v $out/share/themes/Nordic/kde/plasma/look-and-feel $out/share/plasma/desktoptheme/
    mv -v $out/share/themes/Nordic/kde/folders/* $out/share/icons/
    mv -v $out/share/themes/Nordic/kde/cursors/*-cursors $out/share/icons/

    rm -rf $out/share/plasma/look-and-feel/*/contents/{logout,osd,components}
    rm -rf $out/share/plasma/desktoptheme/*/contents/{defaults,splash,previews}
    rm -rf $out/share/Kvantum/*.tar.xz

    mkdir -p $sddm/share/sddm/themes
    mv -v $out/share/themes/Nordic/kde/sddm/* $sddm/share/sddm/themes/

    rm -rf $out/share/themes/Nordic/kde

    # Replace duplicate files with symbolic links to the first file in
    # each set of duplicates, reducing the installed size in about 53%
    jdupes --quiet --link-soft --recurse $out/share

    # FIXME: https://github.com/EliverLara/Nordic/issues/331
    echo "Removing broken symlinks ..."
    find $out -xtype l -print -delete

    runHook postInstall
  '';

  postFixup = ''
    # Propagate sddm theme dependencies to user env otherwise sddm
    # does not find them. Putting them in buildInputs is not enough.

    mkdir -p $sddm/nix-support

    printWords ${kdePackages.breeze-icons} ${kdePackages.libplasma} ${kdePackages.plasma-workspace} \
      >> $sddm/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "Gtk and KDE themes using the Nord color pallete";
    homepage = "https://github.com/EliverLara/Nordic";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
