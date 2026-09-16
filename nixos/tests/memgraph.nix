{ lib, ... }: {
  name = "memgraph";
  containers.machine.services.memgraph.enable = true;
  testScript = { containers, ... }: ''
    import csv
    from shlex import quote

    def mgconsole(cmd: str):
      return list(csv.reader(machine.succeed(f"""
        printf '%s\\n' {quote(cmd)} | tee /dev/stderr \
        | mgconsole --output_format=csv | tee /dev/stderr
      """).splitlines()))

    machine.wait_for_unit("memgraph.service")
    machine.wait_for_open_port(7687)

    assert mgconsole("""
      SHOW VERSION;
    """) == [
      ["version"],
      ['"${containers.machine.services.memgraph.package.version}"'],
    ]
    assert mgconsole("""
      CREATE INDEX ON :Person(name);
    """) == []
    assert mgconsole("""
      SHOW INDEX INFO;
    """) == [
      ["index type",       "label",    "property", "count"],
      ['"label+property"', '"Person"', '["name"]', "0"],
    ]
    assert mgconsole("""
      CREATE CONSTRAINT ON (p:Person)
      ASSERT EXISTS (p.name);
      CREATE CONSTRAINT ON (p:Person)
      ASSERT p.name IS TYPED STRING;
    """) == []
    assert mgconsole("""
      SHOW CONSTRAINT INFO;
    """) == [
      ["constraint type", "label",    "properties", "data_type"],
      ['"exists"',        '"Person"', '"name"',     '""'],
      ['"data_type"',     '"Person"', '"name"',     '"STRING"'],
    ]
    assert mgconsole("""
      CREATE
        (alice:Person {name: "alice"}),
        (bob:Person {name: "bob"}),
        (alice)-[:KNOWS]->(bob),
        (bob)-[:KNOWS]->(alice);
    """) == []
    assert mgconsole("""
      MATCH (n:Person) RETURN count(n) AS people;
    """) == [
      ["people"],
      ["2"],
    ]
    assert mgconsole("""
      MATCH (:Person)-[r:KNOWS]->(:Person)
      RETURN count(r) AS knows;
    """) == [
      ["knows"],
      ["2"],
    ]
  '';

  meta.maintainers = with lib.maintainers; [ kip93 ];
}
