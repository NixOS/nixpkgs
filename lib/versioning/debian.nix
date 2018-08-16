{lib, tools}:
with builtins;
with tools;
let
  injectVersionLetter = s:
    let m = match "([a-zA-Z]+).*|([0-9]|$).*|([-+.~]).*" s; in
    if m == null then
      throw "unexpected in version: ${m}"
    else
      let letters = head m; in
      let numbers = head (tail m); in
      let punc = head (tail (tail m)); in
      if letters != null then
        letters + injectVersionLetter (substring (stringLength letters) (stringLength s) s)
      else if numbers != null then
        injectVersionNumber s
      else if punc == "~" then
        "!" + injectVersionLetter (substring 1 (stringLength s) s)
      else
        "~" + injectVersionPunc s;
  injectVersionPunc = s:
    let m = match "([a-zA-Z]).*|([0-9]|$).*|([-+.~]).*" s; in
    if m == null then
      throw "unexpected in version: ${m}"
    else
      let letters = head m; in
      let numbers = head (tail m); in
      let punc = head (tail (tail m)); in
      if letters != null then
        "$" + injectVersionLetter s
      else if numbers != null then
        "#" + injectVersionNumber s
      else if punc == "~" then
        "!" + injectVersionLetter (substring 1 (stringLength s) s)
      else
        punc + injectVersionLetter (substring 1 (stringLength s) s);
  injectVersionNumber = s:
    let m = match "0*([0-9]+|$).*" s; in
    if m == null then
      throw "unexpected in version: ${m}"
    else if (head m) == "" then
      "0"
    else
      levenCode (head m) + injectVersionPunc (substring (stringLength (head m)) (stringLength s) s);
  injectVersionWithEpoch = s:
    let m = match "([0-9]+):(.*)" s; in
    if m == null then
      "0" + injectVersionLetter s
    else
      let m = match "0*([0-9])*:(.*)" s; in
      levenCode (head m) + injectVersionLetter (head (tail m));
  injectRevision = s:
    let m = match "(.*)-(.*)" s; in
    if m == null then
      injectVersionWithEpoch s + "0"
    else
      injectVersionWithEpoch (head m) + injectVersionLetter (head (tail m));
  in
{
  plainVersion = mkVersioner injectVersionLetter;
  version = mkVersioner injectVersionWithEpoch;
  revision = mkVersioner injectRevision;
}
