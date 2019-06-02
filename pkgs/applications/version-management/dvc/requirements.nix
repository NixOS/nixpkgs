# generated using pypi2nix tool (version: 2.0.0)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -V 3.5 -r requirements.txt -E pkgconfig zlib libjpeg openjpeg libtiff freetype lcms2 libwebp tcl
#

{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python35;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            if [ -e $out/${pkgs.python35.sitePackages}/pip/req/req_install.py ]; then
              sed -i \
                -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"  \
                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"  \
                $out/${pkgs.python35.sitePackages}/pip/req/req_install.py
            fi
          '';
        });
      };
  };

  commonBuildInputs = with pkgs; [ pkgconfig zlib libjpeg openjpeg libtiff freetype lcms2 libwebp tcl ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python35-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = args: pythonPackages.buildPythonPackage (args // { nativeBuildInputs = args.buildInputs; });
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "GitPython" = python.mkDerivation {
      name = "GitPython-2.1.11";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4d/e8/98e06d3bc954e3c5b34e2a579ddf26255e762d21eb24fede458eff654c51/GitPython-2.1.11.tar.gz";
        sha256 = "8237dc5bfd6f1366abeee5624111b9d6879393d84745a507de0fda86043b65a8";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."gitdb2"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gitpython-developers/GitPython";
        license = licenses.bsdOriginal;
        description = "Python Git Library";
      };
    };

    "Pillow" = python.mkDerivation {
      name = "Pillow-6.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/81/1a/6b2971adc1bca55b9a53ed1efa372acff7e8b9913982a396f3fa046efaf8/Pillow-6.0.0.tar.gz";
        sha256 = "809c0a2ce9032cbcd7b5313f71af4bdc5c8c771cb86eb7559afd954cab82ebb5";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-pillow.org";
        license = "UNKNOWN";
        description = "Python Imaging Library (Fork)";
      };
    };

    "appdirs" = python.mkDerivation {
      name = "appdirs-1.4.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz";
        sha256 = "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/ActiveState/appdirs";
        license = licenses.mit;
        description = "A small Python module for determining appropriate platform-specific dirs, e.g. a \"user data dir\".";
      };
    };

    "asciimatics" = python.mkDerivation {
      name = "asciimatics-1.11.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e1/af/07a303e6182bee89727ba688a25ef38c5cb6b60f6bcc4aa87f5aa979ac7b/asciimatics-1.11.0.tar.gz";
        sha256 = "1d0871133c95fa15c603d471ebb77e39b3389877e2ff2ad5ab3bc906d81b5e8c";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [
        self."setuptools-scm"
      ];
      propagatedBuildInputs = [
        self."Pillow"
        self."future"
        self."pyfiglet"
        self."wcwidth"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/peterbrittain/asciimatics";
        license = licenses.asl20;
        description = "A cross-platform package to replace curses (mouse/keyboard input & text colours/positioning) and create ASCII animations";
      };
    };

    "certifi" = python.mkDerivation {
      name = "certifi-2019.3.9";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz";
        sha256 = "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://certifi.io/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };

    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz";
        sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl3;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };

    "colorama" = python.mkDerivation {
      name = "colorama-0.4.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/76/53/e785891dce0e2f2b9f4b4ff5bc6062a53332ed28833c7afede841f46a5db/colorama-0.4.1.tar.gz";
        sha256 = "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tartley/colorama";
        license = licenses.bsdOriginal;
        description = "Cross-platform colored terminal text.";
      };
    };

    "configobj" = python.mkDerivation {
      name = "configobj-5.0.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz";
        sha256 = "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/DiffSK/configobj";
        license = "UNKNOWN";
        description = "Config file reading, writing and validation.";
      };
    };

    "configparser" = python.mkDerivation {
      name = "configparser-3.7.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e2/1c/83fd53748d8245cb9a3399f705c251d3fc0ce7df04450aac1cfc49dd6a0f/configparser-3.7.4.tar.gz";
        sha256 = "da60d0014fd8c55eb48c1c5354352e363e2d30bbf7057e5e171a468390184c75";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jaraco/configparser/";
        license = "UNKNOWN";
        description = "Updated configparser from Python 3.7 for Python 2.6+.";
      };
    };

    "contextlib2" = python.mkDerivation {
      name = "contextlib2-0.5.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/6e/db/41233498c210b03ab8b072c8ee49b1cd63b3b0c76f8ea0a0e5d02df06898/contextlib2-0.5.5.tar.gz";
        sha256 = "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://contextlib2.readthedocs.org";
        license = "PSF License";
        description = "Backports and enhancements for the contextlib module";
      };
    };

    "decorator" = python.mkDerivation {
      name = "decorator-4.4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ba/19/1119fe7b1e49b9c8a9f154c930060f37074ea2e8f9f6558efc2eeaa417a2/decorator-4.4.0.tar.gz";
        sha256 = "86156361c50488b84a3f148056ea716ca587df2f0de1d34750d35c21312725de";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/micheles/decorator";
        license = "new BSD License";
        description = "Better living through Python with decorators";
      };
    };

    "distro" = python.mkDerivation {
      name = "distro-1.4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ca/e3/78443d739d7efeea86cbbe0216511d29b2f5ca8dbf51a6f2898432738987/distro-1.4.0.tar.gz";
        sha256 = "362dde65d846d23baee4b5c058c8586f219b5a54be1cf5fc6ff55c4578392f57";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/nir0s/distro";
        license = licenses.asl20;
        description = "Distro - an OS platform information API";
      };
    };

    "dulwich" = python.mkDerivation {
      name = "dulwich-0.19.11";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/2e/02/42ce6e45a206ccb044d8a3296646497e96b5263624e5862d21da947b9d59/dulwich-0.19.11.tar.gz";
        sha256 = "afbe070f6899357e33f63f3f3696e601731fef66c64a489dea1bc9f539f4a725";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."certifi"
        self."urllib3"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.dulwich.io/";
        license = "Apachev2 or later or GPLv2";
        description = "Python Git Library";
      };
    };

    "dvc" = python.mkDerivation {
      name = "dvc-0.41.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/af/5a/13227c82e4b7a5484df9e2fd714b031637e6e81aa899f22ee5fc027ff5f8/dvc-0.41.3.tar.gz";
        sha256 = "85e5143d0b0aa0b4522fd8ba6e1c8a6fcfb17e6514c773a41908af7d980215b7";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."GitPython"
        self."appdirs"
        self."asciimatics"
        self."colorama"
        self."configobj"
        self."configparser"
        self."distro"
        self."dulwich"
        self."future"
        self."grandalf"
        self."humanize"
        self."inflect"
        self."jsonpath-ng"
        self."nanotime"
        self."networkx"
        self."ply"
        self."pyasn1"
        self."requests"
        self."ruamel.yaml"
        self."schema"
        self."treelib"
        self."zc.lockfile"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://dataversioncontrol.com";
        license = licenses.asl20;
        description = "Git for data scientists - manage your code and data together";
      };
    };

    "future" = python.mkDerivation {
      name = "future-0.17.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/90/52/e20466b85000a181e1e144fd8305caf2cf475e2f9674e797b222f8105f5f/future-0.17.1.tar.gz";
        sha256 = "67045236dcfd6816dc439556d009594abf643e5eb48992e36beac09c2ca659b8";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://python-future.org";
        license = licenses.mit;
        description = "Clean single-source support for Python 3 and 2";
      };
    };

    "gitdb2" = python.mkDerivation {
      name = "gitdb2-2.0.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c4/5c/579abccd59187eaf6b3c8a4a6ecd86fce1dfd818155bfe4c52ac28dca6b7/gitdb2-2.0.5.tar.gz";
        sha256 = "83361131a1836661a155172932a13c08bda2db3674e4caa32368aa6eb02f38c2";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."smmap2"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gitpython-developers/gitdb";
        license = licenses.bsdOriginal;
        description = "Git Object Database";
      };
    };

    "grandalf" = python.mkDerivation {
      name = "grandalf-0.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a2/3f/df0618a962a1744e932f2a4547cb786f5a93df7e2476c99e7f7dbd68039f/grandalf-0.6.tar.gz";
        sha256 = "7471db231bd7338bc0035b16edf0dc0c900c82d23060f4b4d0c4304caedda6e4";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [
        self."pytest-runner"
      ];
      propagatedBuildInputs = [
        self."future"
        self."ply"
        self."pyparsing"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/bdcht/grandalf";
        license = "GPLv2 | EPLv1";
        description = "Graph and drawing algorithms framework";
      };
    };

    "humanize" = python.mkDerivation {
      name = "humanize-0.5.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz";
        sha256 = "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/jmoiron/humanize";
        license = licenses.mit;
        description = "python humanize utilities";
      };
    };

    "idna" = python.mkDerivation {
      name = "idna-2.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz";
        sha256 = "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };

    "inflect" = python.mkDerivation {
      name = "inflect-2.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5e/79/fc91ef0768c6ac564c2d820ff2658b6a82686aeb71145980b71c50d0a122/inflect-2.1.0.tar.gz";
        sha256 = "4ded1b2a6fcf0fc0397419c7727f131a93b67b80d899f2973be7758628e12b73";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jazzband/inflect";
        license = "UNKNOWN";
        description = "Correctly generate plurals, singular nouns, ordinals, indefinite articles; convert numbers to words";
      };
    };

    "jsonpath-ng" = python.mkDerivation {
      name = "jsonpath-ng-1.4.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ba/f3/cd8f8a0bb345985b83e76721e6f64222f92f34a217a4e9720f70427a1b4c/jsonpath-ng-1.4.3.tar.gz";
        sha256 = "b1fc75b877e9b2f46845a455fbdcfb0f0d9c727c45c19a745d02db620a9ef0be";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."decorator"
        self."ply"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/h2non/jsonpath-ng";
        license = licenses.asl20;
        description = "A final implementation of JSONPath for Python that aims to be standard compliant, including arithmetic and binary comparison operators and providing clear AST for metaprogramming.";
      };
    };

    "nanotime" = python.mkDerivation {
      name = "nanotime-0.5.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d5/54/6d5924f59cf671326e7809f4b3f70fa8df535d67e952ad0b6fea02f52faf/nanotime-0.5.2.tar.gz";
        sha256 = "c7cc231fc5f6db401b448d7ab51c96d0a4733f4b69fabe569a576f89ffdf966b";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/jbenet/nanotime/tree/master/python";
        license = licenses.mit;
        description = "nanotime python implementation";
      };
    };

    "networkx" = python.mkDerivation {
      name = "networkx-2.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/85/08/f20aef11d4c343b557e5de6b9548761811eb16e438cee3d32b1c66c8566b/networkx-2.3.zip";
        sha256 = "8311ddef63cf5c5c5e7c1d0212dd141d9a1fe3f474915281b73597ed5f1d4e3d";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."decorator"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://networkx.github.io/";
        license = licenses.bsdOriginal;
        description = "Python package for creating and manipulating graphs and networks";
      };
    };

    "ply" = python.mkDerivation {
      name = "ply-3.11";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz";
        sha256 = "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.dabeaz.com/ply/";
        license = licenses.bsdOriginal;
        description = "Python Lex & Yacc";
      };
    };

    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.4.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz";
        sha256 = "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };

    "pyfiglet" = python.mkDerivation {
      name = "pyfiglet-0.8.post1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f9/02/48293654fb2e4fdeb4d927f00a380230a832744b6c9af757373a72d018d1/pyfiglet-0.8.post1.tar.gz";
        sha256 = "c6c2321755d09267b438ec7b936825a4910fec696292139e664ca8670e103639";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pwaller/pyfiglet";
        license = licenses.mit;
        description = "Pure-python FIGlet implementation";
      };
    };

    "pyparsing" = python.mkDerivation {
      name = "pyparsing-2.4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5d/3a/24d275393f493004aeb15a1beae2b4a3043526e8b692b65b4a9341450ebe/pyparsing-2.4.0.tar.gz";
        sha256 = "1873c03321fc118f4e9746baf201ff990ceb915f433f23b395f5580d1840cb2a";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyparsing/pyparsing/";
        license = licenses.mit;
        description = "Python parsing module";
      };
    };

    "pytest-runner" = python.mkDerivation {
      name = "pytest-runner-5.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d9/6d/4b41a74b31720e25abd4799be72d54811da4b4d0233e38b75864dcc1f7ad/pytest-runner-5.1.tar.gz";
        sha256 = "25a013c8d84f0ca60bb01bd11913a3bcab420f601f0f236de4423074af656e7a";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pytest-runner/";
        license = "UNKNOWN";
        description = "Invoke py.test as distutils command with dependency resolution";
      };
    };

    "requests" = python.mkDerivation {
      name = "requests-2.22.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz";
        sha256 = "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."certifi"
        self."chardet"
        self."idna"
        self."urllib3"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-requests.org";
        license = licenses.asl20;
        description = "Python HTTP for Humans.";
      };
    };

    "ruamel.yaml" = python.mkDerivation {
      name = "ruamel.yaml-0.15.96";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a2/f7/63f04dd8a572b13a41a62b29eb52b64a2136249cc42a933f05d890033eac/ruamel.yaml-0.15.96.tar.gz";
        sha256 = "343ace5ffbab036536a3da65e4cfd31b8292388a389f6305744984581a479b2a";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/ruamel/yaml";
        license = "MIT license";
        description = "ruamel.yaml is a YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order";
      };
    };

    "schema" = python.mkDerivation {
      name = "schema-0.7.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a5/ac/29e4a4d5be1fc8ba1a840853dbec1ab242f6e0bdd09fedb21e8383999fd3/schema-0.7.0.tar.gz";
        sha256 = "44add3ef9016c85ac4b0291b45286a657d0df309b31528ca8d0a9c6d0aa68186";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."contextlib2"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/keleshev/schema";
        license = licenses.mit;
        description = "Simple data validation library";
      };
    };

    "setuptools-scm" = python.mkDerivation {
      name = "setuptools-scm-3.3.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/83/44/53cad68ce686585d12222e6769682c4bdb9686808d2739671f9175e2938b/setuptools_scm-3.3.3.tar.gz";
        sha256 = "bd25e1fb5e4d603dcf490f1fde40fb4c595b357795674c3e5cb7f6217ab39ea5";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/setuptools_scm/";
        license = licenses.mit;
        description = "the blessed package to manage your versions by scm tags";
      };
    };

    "six" = python.mkDerivation {
      name = "six-1.12.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz";
        sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };

    "smmap2" = python.mkDerivation {
      name = "smmap2-2.0.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/3b/ba/e49102b3e8ffff644edded25394b2d22ebe3e645f3f6a8139129c4842ffe/smmap2-2.0.5.tar.gz";
        sha256 = "29a9ffa0497e7f2be94ca0ed1ca1aa3cd4cf25a1f6b4f5f87f74b46ed91d609a";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gitpython-developers/smmap";
        license = licenses.bsdOriginal;
        description = "A pure Python implementation of a sliding window memory map manager";
      };
    };

    "treelib" = python.mkDerivation {
      name = "treelib-1.5.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/17/47/0a8e745a1982ca82ef2149903fc77d5bbf08c4d566f8d238dca7eaf59837/treelib-1.5.5.tar.gz";
        sha256 = "44695f7048b0bd82b45a4fe976611f9fb52902506249d84db255976a5e8738e0";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/caesar0301/treelib";
        license = licenses.asl20;
        description = "A Python 2/3 implementation of tree structure.";
      };
    };

    "urllib3" = python.mkDerivation {
      name = "urllib3-1.25.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz";
        sha256 = "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."certifi"
        self."idna"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };

    "wcwidth" = python.mkDerivation {
      name = "wcwidth-0.1.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz";
        sha256 = "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jquast/wcwidth";
        license = licenses.mit;
        description = "Measures number of Terminal column cells of wide-character codes";
      };
    };

    "zc.lockfile" = python.mkDerivation {
      name = "zc.lockfile-1.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/58/c2/d7c89bdad237b4b7837609172be3e8bf5630796c0020494a15b97ece8eb1/zc.lockfile-1.4.tar.gz";
        sha256 = "95a8e3846937ab2991b61703d6e0251d5abb9604e18412e2714e1b90db173253";
      };
      doCheck = commonDoCheck;
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.python.org/pypi/zc.lockfile";
        license = licenses.zpl21;
        description = "Basic inter-process locks";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
    
  ];
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ commonOverrides ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )