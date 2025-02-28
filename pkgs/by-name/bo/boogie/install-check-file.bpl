// RUN: %parallel-boogie "%s" > "%t"
// RUN: %diff "%s.expect" "%t"
type X;

function {:builtin "MapAdd"} mapadd([X]int, [X]int) : [X]int;
function {:builtin "MapSub"} mapsub([X]int, [X]int) : [X]int;
function {:builtin "MapMul"} mapmul([X]int, [X]int) : [X]int;
function {:builtin "MapDiv"} mapdiv([X]int, [X]int) : [X]int;
function {:builtin "MapMod"} mapmod([X]int, [X]int) : [X]int;
function {:builtin "MapConst"} mapconstint(int) : [X]int;
function {:builtin "MapConst"} mapconstbool(bool) : [X]bool;
function {:builtin "MapAnd"} mapand([X]bool, [X]bool) : [X]bool;
function {:builtin "MapOr"} mapor([X]bool, [X]bool) : [X]bool;
function {:builtin "MapNot"} mapnot([X]bool) : [X]bool;
function {:builtin "MapIte"} mapiteint([X]bool, [X]int, [X]int) : [X]int;
function {:builtin "MapIte"} mapitebool([X]bool, [X]bool, [X]bool) : [X]bool;
function {:builtin "MapLe"} maple([X]int, [X]int) : [X]bool;
function {:builtin "MapLt"} maplt([X]int, [X]int) : [X]bool;
function {:builtin "MapGe"} mapge([X]int, [X]int) : [X]bool;
function {:builtin "MapGt"} mapgt([X]int, [X]int) : [X]bool;
function {:builtin "MapEq"} mapeq([X]int, [X]int) : [X]bool;
function {:builtin "MapIff"} mapiff([X]bool, [X]bool) : [X]bool;
function {:builtin "MapImp"} mapimp([X]bool, [X]bool) : [X]bool;



const FF: [X]bool;
axiom FF == mapconstbool(false);

const TT: [X]bool;
axiom TT == mapconstbool(true);

const MultisetEmpty: [X]int;
axiom MultisetEmpty == mapconstint(0);

function {:inline} MultisetSingleton(x: X) : [X]int
{
  MultisetEmpty[x := 1]
}

function {:inline} MultisetPlus(a: [X]int, b: [X]int) : [X]int
{
  mapadd(a, b)
}

function {:inline} MultisetMinus(a: [X]int, b: [X]int)  : [X]int
{
  mapiteint(mapgt(a, b), mapsub(a, b), mapconstint(0))
}

procedure foo() {
  var x: X;

  assert FF != TT;
  assert mapnot(FF) == TT;

  assert MultisetSingleton(x) != MultisetEmpty;
  assert MultisetPlus(MultisetEmpty, MultisetSingleton(x)) == MultisetSingleton(x);
  assert MultisetMinus(MultisetPlus(MultisetEmpty, MultisetSingleton(x)), MultisetSingleton(x)) == MultisetEmpty;
  assert MultisetMinus(MultisetEmpty, MultisetSingleton(x)) == MultisetEmpty;
}
