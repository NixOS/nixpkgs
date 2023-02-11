{ lib }:
/*
Usage:

  You define you custom builder script by adding all build steps to a list.
  for example:
       builder = writeScript "fsg-4.4-builder"
               (textClosure [doUnpack addInputs preBuild doMake installPhase doForceShare]);

  a step is defined by noDepEntry, fullDepEntry or packEntry.
  To ensure that prerequisite are met those are added before the task itself by
  textClosureDupList. Duplicated items are removed again.

  See trace/nixpkgs/trunk/pkgs/top-level/builder-defs.nix for some predefined build steps

  Attention:

  let
    pkgs = (import <nixpkgs>) {};
  in let
    inherit (pkgs.stringsWithDeps) fullDepEntry packEntry noDepEntry textClosureMap;
    inherit (pkgs.lib) id;

    nameA = noDepEntry "Text a";
    nameB = fullDepEntry "Text b" ["nameA"];
    nameC = fullDepEntry "Text c" ["nameA"];

    stages = {
      nameHeader = noDepEntry "#! /bin/sh \n";
      inherit nameA nameB nameC;
    };
  in
    textClosureMap id stages
    [ "nameHeader" "nameA" "nameB" "nameC"
      nameC # <- added twice. add a dep entry if you know that it will be added once only [1]
      "nameB" # <- this will not be added again because the attr name (reference) is used
    ]

  # result: Str("#! /bin/sh \n\nText a\nText b\nText c\nText c",[])

  [1] maybe this behaviour should be removed to keep things simple (?)
*/

let
  inherit (lib)
    concatStringsSep
    head
    isAttrs
    listToAttrs
    tail
    ;
in
rec {

  /* !!! The interface of this function is kind of messed up, since
     it's way too overloaded and almost but not quite computes a
     topological sort of the depstrings. */

  textClosureList = predefined: arg:
    let
      f = done: todo:
        if todo == [] then {result = []; inherit done;}
        else
          let entry = head todo; in
          if isAttrs entry then
            let x = f done entry.deps;
                y = f x.done (tail todo);
            in { result = x.result ++ [entry.text] ++ y.result;
                 done = y.done;
               }
          else if done ? ${entry} then f done (tail todo)
          else f (done // listToAttrs [{name = entry; value = 1;}]) ([predefined.${entry}] ++ tail todo);
    in (f {} arg).result;

  textClosureMap = f: predefined: names:
    concatStringsSep "\n" (map f (textClosureList predefined names));

  noDepEntry = text: {inherit text; deps = [];};
  fullDepEntry = text: deps: {inherit text deps;};
  packEntry = deps: {inherit deps; text="";};

  stringAfter = deps: text: { inherit text deps; };

}
