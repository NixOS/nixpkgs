{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  chez,
  llvmPackages_18,
  nodejs,
  typescript,
  rustPlatform,
  makeWrapper,
}:

let
  nanopass = fetchFromGitHub {
    owner = "nanopass";
    repo = "nanopass-framework-scheme";
    rev = "f3100cedaf9ed7fb89647a770d855997b32cf17e";
    hash = "sha256-NsY+V0r/lgycSIVTeHcNjJ398YwEijLlaGySNdTopxw=";
  };
  rough-draft = fetchFromGitHub {
    owner = "akeep";
    repo = "rough-draft";
    rev = "6a5e64aa325d2fd7ab1e161cfcb45ba2f9a057de";
    hash = "sha256-/as+XqStSyHc/vLImmGgowxgVjqi/jITolH9D6AJfek=";
  };
  chezForBuild =
    if stdenv.hostPlatform.isDarwin then chez.override { stdenv = llvmPackages_18.stdenv; } else chez;
  scheme = lib.getExe' chezForBuild "scheme";

  compactSrc = fetchFromGitHub {
    owner = "LFDT-Minokawa";
    repo = "compact";
    rev = "b5675ec2354da531e5fb2541fefaaf10c6369444";
    hash = "sha256-HCpxBXYdFoHBx98KlWmurStkN0N9/hrOXhxvt2Np/RE=";
  };

  midnightLedgerSrc = fetchFromGitHub {
    owner = "midnightntwrk";
    repo = "midnight-ledger";
    rev = "ledger-8.0.2";
    hash = "sha256-5RvXdcs2piO2f4LT3zEMQvgVcK6V/8bXYAmfsvvLB5w=";
  };

  param-for =
    k:
    "https://midnight-s3-fileshare-dev-eu-west-1.s3.eu-west-1.amazonaws.com/bls_midnight_2p${builtins.toString k}";

  publicParams = stdenvNoCC.mkDerivation {
    pname = "midnight-public-params";
    version = "0.1.0";
    srcs = [
      (fetchurl {
        url = param-for 0;
        hash = "sha256-WbMLMRSjTMu/tZk3bhePuNmzNmyuIXTC8dog51hH+CM=";
      })
      (fetchurl {
        url = param-for 1;
        hash = "sha256-u+BP48cNDBOER8sIa0ut3DDLi7KgBBFLwC5vc5UWKA4=";
      })
      (fetchurl {
        url = param-for 2;
        hash = "sha256-gOFVaPoaARfbiTI5vn+l40przDqMO/p3CVNLnLiOtsE=";
      })
      (fetchurl {
        url = param-for 3;
        hash = "sha256-S+gnpkchk9+A2PCLSyWoW670Nv3Rll2Jtq+J9OxOmeI=";
      })
      (fetchurl {
        url = param-for 4;
        hash = "sha256-Iy9AH60Qx934go0qpMhcZQbF2gl5WZjOyuufdfyPato=";
      })
      (fetchurl {
        url = param-for 5;
        hash = "sha256-ChySKfMV/Bho/yX2aPuDrsTQn08jpwa1GXxpLGGdcsY=";
      })
      (fetchurl {
        url = param-for 6;
        hash = "sha256-zyrWvn0P7fW+wqqjX2vkrKMwU9dCaP31qlT8sokept8=";
      })
      (fetchurl {
        url = param-for 7;
        hash = "sha256-6CrokMCAGINV83/q/+kTclhM2BBhUILZFD1N7ART/Z0=";
      })
      (fetchurl {
        url = param-for 8;
        hash = "sha256-kJtwdVHqrqeYKOiDzeb8RqsVmGw7HXkb7UYsnigFyTM=";
      })
      (fetchurl {
        url = param-for 9;
        hash = "sha256-uQCfEJi87//sPEYas6XjoX9+VZnw8Ixw/NxVqJInvL0=";
      })
      (fetchurl {
        url = param-for 10;
        hash = "sha256-RrIpCTPL7Uw3iInkupcfGpKIgzH/sJRmrNT/YaHiy0I=";
      })
      (fetchurl {
        url = param-for 11;
        hash = "sha256-mQFYnXlW/1i+DYVWmy9FW3e1jDdYAm/7W75IBwALltE=";
      })
      (fetchurl {
        url = param-for 12;
        hash = "sha256-7wjrP89i349yxRXP+gJ+aBgItTDLAW7qEEEVVF721cg=";
      })
      (fetchurl {
        url = param-for 13;
        hash = "sha256-0zJJEJacTMVBQ7gEW2SeXDpL1ft7j4X+G3cPZAzhyAM=";
      })
      (fetchurl {
        url = param-for 14;
        hash = "sha256-/CUwFoheyDDpeAjJ7JILtcq1whr1kDgKbLXrBTjiskQ=";
      })
      (fetchurl {
        url = param-for 15;
        hash = "sha256-ckx8PXeRSLsRPH7pwDSy8n2xbmvfMV/ekBBam60Asd4=";
      })
      (fetchurl {
        url = param-for 16;
        hash = "sha256-Cch3IW1libNwJj4Yr0CgMKkBtBp6fDfvWMmQHbQfBcY=";
      })
      (fetchurl {
        url = param-for 17;
        hash = "sha256-Sp72x8Bhmqt07t5EsT51PjulRQigLdO3EGqUmqu3O3Q=";
      })
    ];
    dontUnpack = true;
    installPhase = ''
      mkdir $out
      for src in $srcs; do
        name=$(echo $src | sed -e 's/^.*-//')
        cp $src $out/$name
      done
    '';
  };

  zkir = rustPlatform.buildRustPackage {
    pname = "zkir";
    version = "2.1.0";
    src = midnightLedgerSrc;
    cargoHash = "sha256-CJBnOnj0dGpvOIv49fTf7JVT1IKgICUvikaz3iAoxRg=";
    cargoBuildFlags = "--package midnight-zkir --features binary";
    MIDNIGHT_PP = "${publicParams}";
    buildInputs = [ publicParams ];
    doCheck = false;
  };

in
stdenv.mkDerivation {
  pname = "compactc";
  version = "0.31.0";

  src = compactSrc;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    chezForBuild
    nodejs
    typescript
    makeWrapper
  ];

  env = {
    CHEZSCHEMELIBDIRS = "compiler::obj/compiler:third_party/compiler::obj/third_party/compiler:${nanopass}::obj/nanopass:${rough-draft}/src::obj/rough-draft:srcMaps::obj/srcMaps::obj/compiler";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    mkdir -p obj/compiler
    sed -e 's|/usr/bin/env .*|${scheme} --program|' compiler/compactc.ss > obj/compiler/compactc.ss
    sed -e 's|/usr/bin/env .*|${scheme} --program|' compiler/format-compact.ss > obj/compiler/format-compact.ss
    sed -e 's|/usr/bin/env .*|${scheme} --program|' compiler/fixup-compact.ss > obj/compiler/fixup-compact.ss
    patchShebangs --host .

    ${scheme} -q << 'END'
      (reset-handler abort)
      (optimize-level 2)
      (compile-imported-libraries #t)
      (generate-wpo-files #t)
      (generate-inspector-information #f)
      (compile-profile #f)
      (compile-program "obj/compiler/compactc.ss" "obj/compiler/compactc.so")
      (compile-program "obj/compiler/format-compact.ss" "obj/compiler/format-compact.so")
      (compile-program "obj/compiler/fixup-compact.ss" "obj/compiler/fixup-compact.so")
      (compile-whole-program "obj/compiler/compactc.wpo" "obj/compactc")
      (compile-whole-program "obj/compiler/format-compact.wpo" "obj/format-compact")
      (compile-whole-program "obj/compiler/fixup-compact.wpo" "obj/fixup-compact")
    END
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/zkir-params
    cp obj/compactc $out/bin/
    cp obj/format-compact $out/bin/
    cp obj/fixup-compact $out/bin/
    cp -r ${publicParams}/* $out/lib/zkir-params/
    cp ${zkir}/bin/zkir $out/bin/.zkir-raw
    chmod +x $out/bin/*
    makeWrapper $out/bin/.zkir-raw $out/bin/zkir \
      --set MIDNIGHT_PP "$out/lib/zkir-params"
    runHook postInstall
  '';

  meta = {
    description = "Compact Compiler + zkir — Smart contract language for Midnight Network";
    homepage = "https://midnight.network";
    license = lib.licenses.asl20;
    platforms = lib.intersectLists chez.meta.platforms (with lib.platforms; darwin ++ linux);
    maintainers = [ lib.maintainers.anshsonkusare ];
    mainProgram = "compactc";
  };
}
