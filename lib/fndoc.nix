{
  docFn = {
    description,
    fn,
    examples ? [],
    example ? null
  }:
  let documentedFunction =
    {
      type = "documentedFunction";
      __functor = self: x: fn x;
      inherit description example examples;
    };
  in documentedFunction;
}
