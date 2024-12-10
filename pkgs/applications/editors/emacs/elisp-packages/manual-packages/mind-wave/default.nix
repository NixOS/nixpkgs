{
  lib,
  pkgs,
  melpaBuild,
  substituteAll,
}:
# To use this package with emacs-overlay:
# nixpkgs.overlays = [
#   inputs.emacs-overlay.overlay
#   (final: prev: {
#     emacs30 = prev.emacsGit.overrideAttrs (old: {
#       name = "emacs30";
#       version = inputs.emacs-upstream.shortRev;
#       src = inputs.emacs-upstream;
#     });
#     emacsWithConfig = prev.emacsWithPackagesFromUsePackage {
#       config = let
#         readRecursively = dir:
#           builtins.concatStringsSep "\n"
#           (lib.mapAttrsToList (name: value:
#             if value == "regular"
#             then builtins.readFile (dir + "/${name}")
#             else
#               (
#                 if value == "directory"
#                 then readRecursively (dir + "/${name}")
#                 else []
#               ))
#           (builtins.readDir dir));
#       in
#         # your home-manager config
#         readRecursively ./home/modules/emacs;
#       alwaysEnsure = true;
#       package = final.emacs30;
#       extraEmacsPackages = epkgs: [
#         epkgs.use-package
#         (epkgs.melpaBuild rec {
#           # ...
#         })
#       ];
#       override = epkgs:
#         epkgs
#         // {
#           # ...
#         };
#     };
#   })
# ];
melpaBuild rec {
  pname = "mind-wave";
  version = "20230523.0332"; # 03:32 UTC
  src = pkgs.fetchFromGitHub {
    owner = "manateelazycat";
    repo = "mind-wave";
    rev = "5109162b74872091c5090a28389bef8f7020274c";
    sha256 = "sha256-ZyXrpb0GLWSGnMsVIGL9qALSBCeIWNF0UwkCFgCKnu8=";
  };
  commit = "5109162b74872091c5090a28389bef8f7020274c";
  # elisp dependencies
  packageRequires = [
    pkgs.emacsPackages.markdown-mode
  ];
  buildInputs = [
    (pkgs.python3.withPackages (
      ps: with ps; [
        openai
        epc
        sexpdata
        six
      ]
    ))
  ];
  recipe = pkgs.writeText "recipe" ''
    (mind-wave
    :repo "manateelazycat/mind-wave"
    :fetcher github
    :files
    ("mind-wave.el"
    "mind-wave-epc.el"
    "mind_wave.py"
    "utils.py"))
  '';
  doCheck = true;
  passthru.updateScript = pkgs.unstableGitUpdater { };
  meta = with lib; {
    description = " Emacs AI plugin based on ChatGPT API ";
    homepage = "https://github.com/manateelazycat/mind-wave";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ yuzukicat ];
  };
}
