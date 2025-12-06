{
  lib,
  runCommand,
  prisma,
  prisma-engines,
  sqlite-interactive,
  openssl,
}:

let
  prismaMajorVersion = lib.versions.majorMinor prisma.version;
  enginesMajorVersion = lib.versions.majorMinor prisma-engines.version;
in
runCommand "prisma-cli-tests"
  {
    nativeBuildInputs = [
      prisma
      sqlite-interactive
      openssl
    ];
    meta.timeout = 60;
  }
  ''
    mkdir $out
    cd $out

    # Set HOME to a writable directory (Nix sandbox sets it to /homeless-shelter)
    export HOME=$TMPDIR

    if [ "${prismaMajorVersion}" != "${enginesMajorVersion}" ]; then
      echo "prisma in version ${prismaMajorVersion} and prisma-engines in ${enginesMajorVersion}. Major versions must match."
      exit 1
    fi

    # Ensure CLI runs
    prisma --help > /dev/null

    # Create project structure manually (prisma init requires network access)
    mkdir -p prisma node_modules

    # The config file needs to be able to import from 'prisma/config'
    # so we symlink the prisma package into node_modules
    ln -s ${prisma}/lib/prisma/packages/cli node_modules/prisma

    cat << 'EOF' > prisma.config.ts
    import { defineConfig } from 'prisma/config'

    export default defineConfig({
      schema: 'prisma/schema.prisma',
      datasource: {
        url: 'file:prisma/test.db',
      },
    })
    EOF

    # Create a simple data model
    cat << 'EOF' > prisma/schema.prisma
    datasource db {
      provider = "sqlite"
    }

    generator client {
      provider = "prisma-client"
    }

    model A {
      id Int    @id @default(autoincrement())
      b  String @default("foo")
    }
    EOF

    # Format
    prisma format > /dev/null

    # Create the database
    prisma db push > /dev/null

    # The database file should exist and be a SQLite database
    sqlite3 prisma/test.db "SELECT id, b FROM A" > /dev/null

    # Introspect the database
    prisma db pull > /dev/null
  ''
