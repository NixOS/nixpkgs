#include <memory>
#include <stdio.h>
#include <functional>
#include <string>
#include <vector>

#include <sqlite3.h>

int queryPackages(std::string system, std::string program,
                  std::vector<std::string> &packages) {
  sqlite3 *raw_db = nullptr;
  if (sqlite3_open(DB_PATH, &raw_db) != SQLITE_OK) {
    fprintf(stderr, "cannot open database \"%s\": %s\n", DB_PATH,
            sqlite3_errmsg(raw_db));
  };
  std::unique_ptr<sqlite3, std::function<void(sqlite3*)>> db(raw_db, [](auto db) { sqlite3_close(db); });

  const char *sql =
      "select package from Programs where system = ? and name = ?;";

  sqlite3_stmt *raw_stmt = nullptr;
  if (sqlite3_prepare_v2(db.get(), sql, -1, &raw_stmt, NULL) != SQLITE_OK) {
    fprintf(stderr, "Failed to prepare query: %s\n", sqlite3_errmsg(db.get()));
    return 1;
  }
  std::unique_ptr<sqlite3_stmt, std::function<void(sqlite3_stmt*)>> stmt(raw_stmt, [](auto stmt) { sqlite3_finalize(stmt); });

  if (sqlite3_bind_text(stmt.get(), 1, system.c_str(), -1, 0) != SQLITE_OK) {
    fprintf(stderr, "Failed to bind system parameter: %s\n",
            sqlite3_errmsg(db.get()));
    return 1;
  };
  if (sqlite3_bind_text(stmt.get(), 2, program.c_str(), -1, 0) != SQLITE_OK) {
    fprintf(stderr, "Failed to bind program parameter: %s\n",
            sqlite3_errmsg(db.get()));
    return 1;
  };

  while (sqlite3_step(stmt.get()) == SQLITE_ROW) {
    packages.push_back((const char *)(sqlite3_column_text(stmt.get(), 0)));
  }

  return 0;
}

int main(int argc, char **argv) {
  const char *system = getenv("NIX_SYSTEM");
  const char *program = argv[1];

  if (!system) {
    system = NIX_SYSTEM;
  }

  if (argc < 2) {
    fprintf(stderr, "USAGE: %s PROGRAM\n", argv[0]);
    return 1;
  }

  std::vector<std::string> packages = {};
  if (queryPackages(system, program, packages) < 0) {
    return 1;
  };

  if (packages.size()) {
    auto advice = packages.size() > 1 ?
      "It is provided by several packages. You can install it by typing on of the of following commands:\n" :
      "You can install it by typing:";
    fprintf(stderr,
            "The program '%s' is currently not installed. %s\n",
            program, advice);
    for (auto pkg : packages) {
      fprintf(stderr, "  nix-env -iA nixos.%s\n", pkg.c_str());
    }
  } else {
    fprintf(stderr, "%s: command not found\n", program);
  }

  return 127;
}
