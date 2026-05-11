{
  lib,
  runCommand,
  prisma_6,
  prisma-engines_6,
  sqlite-interactive,
  openssl,
}:

let
  prismaMajorVersion = lib.versions.majorMinor prisma_6.version;
  enginesMajorVersion = lib.versions.majorMinor prisma-engines_6.version;
in
runCommand "prisma-cli-tests"
  {
    nativeBuildInputs = [
      prisma_6
      sqlite-interactive
      openssl
    ];
    meta.timeout = 60;
  }
  ''
    mkdir $out
    cd $out

    if [ "${prismaMajorVersion}" != "${enginesMajorVersion}" ]; then
      echo "prisma in version ${prismaMajorVersion} and prisma-engines in ${enginesMajorVersion}. Major versions must match."
      exit 1
    fi

    # Ensure CLI runs
    prisma --help > /dev/null

    # Init a new project without prisma init, which needs
    # network access
    mkdir prisma

    # Create a simple data model
    cat << EOF > prisma/schema.prisma
    datasource db {
      provider = "sqlite"
      url      = "file:test.db"
    }

    generator js {
      provider = "prisma-client-js"
    }

    model A {
      id Int    @id @default(autoincrement())
      b  String @default("foo")
    }
    EOF

    # Format
    prisma format > /dev/null

    # Create the database
    prisma db push --skip-generate > /dev/null

    # The database file should exist and be a SQLite database
    sqlite3 prisma/test.db "SELECT id, b FROM A" > /dev/null

    # Introspect the database
    prisma db pull > /dev/null
  ''
