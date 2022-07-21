rec {
  /* mkSymbol returns a value that is only comparable to itself. The main
     use is to create unique identifiers or labels and enables a form of weak
     encapsulation, or information hiding.

     The reason this works is that function equality works by comparing the
     memory location. So two mkSymbol calls with the same description will
     generate two different singletons.

     Usage:
       mkSymbol "mydescription"
  */
  mkSymbol = description:
    { __toString = _: description; };

  # ---- list of global symbols ----
}
