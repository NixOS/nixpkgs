args: with args; let 

  #  hint: eclipse -data <dir to save global eclipse settings>

  eclipsePlugin = name : src : stdenv.mkDerivation {
    inherit src;
    name = "${name}-eclipse-plugin";
    phases = "unpackPhase";
    buildInputs = [ args.unzip ];
    unpackPhase = ''
      mkdir tmp; cd tmp
      unpackFile "$src"
      [ -d ./eclipse ] || { # if plugin doesn't contain the eclipse directory itself create it (eg viPlugin)
        mkdir "$TMP/eclipse"
        mv * "$TMP/eclipse"
        cd "$TMP"
      }
      ensureDir $out;
      mv eclipse "$out"
    '';
  };

  eclipseEnv = {name, eclipse, links}: runCommand name { inherit links eclipse; } ''
    ensureDir $out/eclipse/links;
    cp -r "$eclipse/bin" "$out/bin"
    for f in $eclipse/eclipse/*; do
       # using ln eclipse doesn't take the correct link folder :-( (TODO)
       # ln -s "$f" "$out/eclipse/$(basename "$f")"
       cp -r "$f" "$out/eclipse/$(basename "$f")"
    done
    # create links
    for link in $links; do
      echo "path=$link" >> "$out/eclipse/links/$(basename "$link").link"
    done
  '';

  # mmh, this derivation is superfluous. We could also create them directly
  # instead of symlinking them into the final env build by buildEnv
  linkFile = deriv : writeTextFile {
    name = "${deriv.name}-eclipse-feature-link";
    destination = "/eclipse/links/${deriv.name}.link";
  };

  attr = rec {
    eclipse = import ( ../eclipse-new + "/${version}/eclipse.nix") args; # without any additional plugins, why can't I use ./ instead of ../eclipse-new ?

    plugins = rec {

      viPlugin = { # see its license!
        plugin = eclipsePlugin "viPlugin_1.15.6" (fetchurl {
          url = http://www.satokar.com/viplugin/files/viPlugin_1.15.6.zip;
          sha256 = "0p53q45a754j143pnnp51rjwj7lzawcxfy9xzpjasdic4a2l0f96";
          # license = "Other/Proprietary License with Free Trial";
        });
      };

      # PHP developement
      emfSdoXsdSDK232 = {
        plugin = eclipsePlugin "emf-sdo-xsd-SDK-2.3.2" (fetchurl {
          url = http://eclipsemirror.yoxos.com/eclipse.org/modeling/emf/emf/downloads/drops/2.3.2/R200802051830/emf-sdo-xsd-SDK-2.3.2.zip;
          sha256 = "1k20fn47x1giwhc80rzkqaw3mn0p3861sjp7aw39842lv2hjwn1c";
        });
      };
      gefSDK332 = {
        plugin = eclipsePlugin "GEF-SDK-3.3.2" (fetchurl {
          url = http://ftp-stud.fht-esslingen.de/pub/Mirrors/eclipse/tools/gef/downloads/drops/3.3.2/R200802211602/GEF-SDK-3.3.2.zip;
          sha256 = "1pk5qlwk0iyvs85s966y96ks8vq1g81fivvbf4lh43155rg0z037";
        });
      };
      wtpSdkR202X = {
        plugin = eclipsePlugin "wtp-sdk-R-2.0.2-20080223205547" (fetchurl {
          url = http://ftp.wh2.tu-dresden.de/pub/mirrors/eclipse/webtools/downloads/drops/R2.0/R-2.0.2-20080223205547/wtp-sdk-R-2.0.2-20080223205547.zip;
          sha256 = "0hmmmqzcd67jir2gmjd0xri5w2434xb2dk21hpgcv2qp0h9hhx0f";
        });
      };
      pdt = {
        deps = [ wtpSdkR202X gefSDK332 emfSdoXsdSDK232 ];
        plugin = eclipsePlugin "pdt-runtime-1.0.3" (fetchurl {
          url = http://sunsite.informatik.rwth-aachen.de:3080/eclipse/tools/pdt/downloads/drops/1.0.3/R200806030000/pdt-runtime-1.0.3.zip;
          sha256 = "0wd2vc9bqrk5mqj5al2ichm8lxlf7gwifsb9lzv1d896j04ilm96";
        });
      };
    };
  }; 
  pluginToList = a : [ a.plugin ] ++ lib.optionals (a ? deps ) (lib.concatMap pluginToList a.deps);
  in
  eclipseEnv { 
    name = "eclipse-${version}-with-plugins";
    inherit (attr) eclipse;
    links =  
        # example custom config: eclipse = {  plugins = {eclipse, version, plugins } : let p = plugins; in [p.pdt]; };
        let userChosenPlugins = (getConfig [ "eclipse" "plugins" ] ( {eclipse, version, plugins} : [] ))
                        { inherit (attr) eclipse plugins; inherit version; };
        in # concatenate plugins and plugin dependencies
           (lib.uniqList { inputList = lib.concatMap pluginToList userChosenPlugins; });
  }
