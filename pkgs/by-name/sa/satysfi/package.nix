{
  lib,
  fetchFromGitHub,
  ocaml-ng,
  ipaexfont,
  junicode,
  lmodern,
  lmmath,
  which,
  mergeSatysfiHash,
  packages ? [ ],
}:
let
  camlpdf = ocamlPackages.camlpdf.overrideAttrs (o: {
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "camlpdf";
      rev = "v2.3.1+satysfi";
      sha256 = "1s8wcqdkl1alvfcj67lhn3qdz8ikvd1v64f4q6bi4c0qj9lmp30k";
    };
    nativeBuildInputs = [ which ] ++ o.nativeBuildInputs;
  });
  yojson-with-position = ocamlPackages.buildDunePackage {
    pname = "yojson-with-position";
    version = "1.4.2";
    src = fetchFromGitHub {
      owner = "gfngfn";
      repo = "yojson-with-position";
      rev = "v1.4.2+satysfi";
      sha256 = "17s5xrnpim54d1apy972b5l08bph4c0m5kzbndk600fl0vnlirnl";
    };
    nativeBuildInputs = [ ocamlPackages.cppo ];
    propagatedBuildInputs = [ ocamlPackages.biniou ];
    inherit (ocamlPackages.yojson) meta;
  };
  ocamlPackages = ocaml-ng.ocamlPackages_4_14;
  version = "0.0.11";
  collectSATySFiPackages =
    packages:
    lib.foldl' (
      acc: pkg:
      if pkg != null && lib.elem pkg acc then
        acc
      else
        acc ++ [ pkg ] ++ collectSATySFiPackages (pkg.dependencies or [ ])
    ) [ ] packages;
in
ocamlPackages.buildDunePackage {
  pname = "satysfi";
  inherit version;

  src = fetchFromGitHub {
    owner = "gfngfn";
    repo = "SATySFi";
    tag = "v${version}";
    hash = "sha256-eeeoUVTGId56SQvrmmMc7nwH/blrXgwcw3+0FLbvc34=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    substituteInPlace src/frontend/main.ml --replace \
    '/usr/local/share/satysfi"; "/usr/share/satysfi' \
    $out/share/satysfi
  '';

  nativeBuildInputs = with ocamlPackages; [
    menhir
    cppo
  ];

  buildInputs =
    [
      camlpdf
      yojson-with-position
    ]
    ++ (with ocamlPackages; [
      menhirLib
      batteries
      camlimages
      core_kernel
      ppx_deriving
      uutf
      omd
      re
      otfed
    ]);

  postInstall = ''
    mkdir -p $out/share/satysfi/dist/fonts
    cp -r lib-satysfi/dist/ $out/share/satysfi/
    cp -r \
      ${ipaexfont}/share/fonts/opentype/* \
      ${lmodern}/share/fonts/opentype/public/lm/* \
      ${lmmath}/share/fonts/opentype/latinmodern-math.otf \
      ${junicode}/share/fonts/truetype/Junicode-{Bold,BoldItalic,Italic}.ttf \
      $out/share/satysfi/dist/fonts/
    cp ${junicode}/share/fonts/truetype/Junicode-Regular.ttf \
      $out/share/satysfi/dist/fonts/Junicode.ttf

    for pkg in ${
      lib.concatStringsSep " " (map (p: "${p}/share/satysfi/dist") (collectSATySFiPackages packages))
    }; do
      if [ -d "$pkg" ]; then
        for item in "$pkg"/*; do
          bn="$(basename "$item")"
          if [ "$bn" = "hash" ]; then
            continue
          fi
          cp -r "$item" "$out/share/satysfi/dist/"
        done

        if [ -d "$pkg/hash" ]; then
          for newHash in "$pkg/hash"/*.satysfi-hash; do
            if [ -f "$newHash" ]; then
              oldHash="$out/share/satysfi/dist/hash/$(basename "$newHash")"
              if [ ! -f "$oldHash" ]; then
                cp "$newHash" "$oldHash"
              else
                echo "Merging $newHash -> $oldHash"
                ${lib.getExe mergeSatysfiHash} "$oldHash" "$newHash" "$oldHash"
              fi
            fi
          done
        fi
      fi
    done
  '';

  meta = {
    homepage = "https://github.com/gfngfn/SATySFi";
    description = "Statically-typed, functional typesetting system";
    changelog = "https://github.com/gfngfn/SATySFi/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      mt-caret
      momeemt
    ];
    platforms = lib.platforms.all;
    mainProgram = "satysfi";
  };
}
