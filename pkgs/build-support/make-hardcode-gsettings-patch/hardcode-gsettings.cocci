/**
 * Since Nix does not have a standard location like /usr/share where GSettings system
 * could look for schemas, we need to point the software to a correct location somehow.
 * For executables, we handle this using wrappers but this is not an option for libraries like e-d-s.
 * Instead, we patch the source code to look for the schema in a schema source
 * through a hardcoded path to the schema.
 *
 * For each schema id referenced in the source code (e.g. org.gnome.evolution),
 * a variable name such as `EVOLUTION` must be provided in the ./glib-schema-to-var.json JSON file.
 * It will end up in the resulting patch as `@EVOLUTION@` placeholder, which should be replaced at build time
 * with a path to the directory containing a `gschemas.compiled` file that includes the schema.
 */

@initialize:python@
@@
import json

cpp_constants = {}

def register_cpp_constant(const_name, val):
    cpp_constants[const_name] = val.strip()

def resolve_cpp_constant(const_name):
    return cpp_constants.get(const_name, const_name)

with open("./glib-schema-to-var.json") as mapping_file:
    schema_to_var = json.load(mapping_file);

def get_schema_directory(schema_id):
    # Sometimes the schema id is referenced using C preprocessor #define constant in the same file
    # let’s try to resolve it first.
    schema_id = resolve_cpp_constant(schema_id.strip()).strip('"')
    if schema_id in schema_to_var:
        return f'"@{schema_to_var[schema_id]}@"'
    raise Exception(f"Unknown schema path {schema_id!r}, please add it to ./glib-schema-to-var.json")

@find_cpp_constants@
identifier const_name;
expression val;
@@

#define const_name val

@script:python record_cpp_constants depends on find_cpp_constants@
const_name << find_cpp_constants.const_name;
val << find_cpp_constants.val;
@@

register_cpp_constant(const_name, val)


@depends on ever record_cpp_constants || never record_cpp_constants@
// We want to run after #define constants have been collected but even if there are no #defines.
expression SCHEMA_ID;
expression settings;
// Coccinelle does not like autocleanup macros in + sections,
// let’s use fresh id with concatenation to produce the code as a string.
fresh identifier schema_source_decl = "g_autoptr(GSettingsSchemaSource) " ## "schema_source";
fresh identifier schema_decl = "g_autoptr(GSettingsSchema) " ## "schema";
fresh identifier SCHEMA_DIRECTORY = script:python(SCHEMA_ID) { get_schema_directory(SCHEMA_ID) };
@@
-settings = g_settings_new(SCHEMA_ID);
+{
+	schema_source_decl;
+	schema_decl;
+	schema_source = g_settings_schema_source_new_from_directory(SCHEMA_DIRECTORY,
+	                                                            g_settings_schema_source_get_default(),
+	                                                            TRUE,
+	                                                            NULL);
+	schema = g_settings_schema_source_lookup(schema_source, SCHEMA_ID, FALSE);
+	settings = g_settings_new_full(schema, NULL, NULL);
+}


@depends on ever record_cpp_constants || never record_cpp_constants@
// We want to run after #define constants have been collected but even if there are no #defines.
expression SCHEMA_ID;
expression settings;
expression BACKEND;
// Coccinelle does not like autocleanup macros in + sections,
// let’s use fresh id with concatenation to produce the code as a string.
fresh identifier schema_source_decl = "g_autoptr(GSettingsSchemaSource) " ## "schema_source";
fresh identifier schema_decl = "g_autoptr(GSettingsSchema) " ## "schema";
fresh identifier SCHEMA_DIRECTORY = script:python(SCHEMA_ID) { get_schema_directory(SCHEMA_ID) };
@@
-settings = g_settings_new_with_backend(SCHEMA_ID, BACKEND);
+{
+   schema_source_decl;
+   schema_decl;
+   schema_source = g_settings_schema_source_new_from_directory(SCHEMA_DIRECTORY,
+                                                               g_settings_schema_source_get_default(),
+                                                               TRUE,
+                                                               NULL);
+   schema = g_settings_schema_source_lookup(schema_source, SCHEMA_ID, FALSE);
+   settings = g_settings_new_full(schema, BACKEND, NULL);
+}


@depends on ever record_cpp_constants || never record_cpp_constants@
// We want to run after #define constants have been collected but even if there are no #defines.
expression SCHEMA_ID;
expression settings;
expression BACKEND;
expression PATH;
// Coccinelle does not like autocleanup macros in + sections,
// let’s use fresh id with concatenation to produce the code as a string.
fresh identifier schema_source_decl = "g_autoptr(GSettingsSchemaSource) " ## "schema_source";
fresh identifier schema_decl = "g_autoptr(GSettingsSchema) " ## "schema";
fresh identifier SCHEMA_DIRECTORY = script:python(SCHEMA_ID) { get_schema_directory(SCHEMA_ID) };
@@
-settings = g_settings_new_with_backend_and_path(SCHEMA_ID, BACKEND, PATH);
+{
+   schema_source_decl;
+   schema_decl;
+   schema_source = g_settings_schema_source_new_from_directory(SCHEMA_DIRECTORY,
+                                                               g_settings_schema_source_get_default(),
+                                                               TRUE,
+                                                               NULL);
+   schema = g_settings_schema_source_lookup(schema_source, SCHEMA_ID, FALSE);
+   settings = g_settings_new_full(schema, BACKEND, PATH);
+}


@depends on ever record_cpp_constants || never record_cpp_constants@
// We want to run after #define constants have been collected but even if there are no #defines.
expression SCHEMA_ID;
expression settings;
expression PATH;
// Coccinelle does not like autocleanup macros in + sections,
// let’s use fresh id with concatenation to produce the code as a string.
fresh identifier schema_source_decl = "g_autoptr(GSettingsSchemaSource) " ## "schema_source";
fresh identifier schema_decl = "g_autoptr(GSettingsSchema) " ## "schema";
fresh identifier SCHEMA_DIRECTORY = script:python(SCHEMA_ID) { get_schema_directory(SCHEMA_ID) };
@@
-settings = g_settings_new_with_path(SCHEMA_ID, PATH);
+{
+   schema_source_decl;
+   schema_decl;
+   schema_source = g_settings_schema_source_new_from_directory(SCHEMA_DIRECTORY,
+                                                               g_settings_schema_source_get_default(),
+                                                               TRUE,
+                                                               NULL);
+   schema = g_settings_schema_source_lookup(schema_source, SCHEMA_ID, FALSE);
+   settings = g_settings_new_full(schema, NULL, PATH);
+}
