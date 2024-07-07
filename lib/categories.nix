/* List of categories
    ```nix
    handle = {
      # Required
      name = "Category Name";
      description = ''
        Description of category
      '';
      relatedCategories = [ related01 related02 . . . ];
    };
    ```

    where

    - `handle` is the handle you are going to use in nixpkgs expressions;
       usually the same as the name but in camelCase
    - `name` is the category name
    - `description` is a description of the category
    - `relatedCategories` is a (possibly empty) list of related categories (like
      the `handle` above)

    More fields may be added in the future.

    When editing this file:
     * do not modify any of
         - mainCategories
         - additionalCategories
         - reservedCategories
       except by reasons of force majeure (e.g. an update on the Freedesktop.org
       Desktop Menu Specification);
     * keep the lists alphabetically sorted;
     * test the validity of the format with:
         nix-build lib/tests/categories.nix
*/
{ lib }:

let
  mainCategories = {
  };

  additionalCategories = {
  };

  reservedCategories = {
  };

  # "Custom" list of categories for the use of Nixpkgs
  nixpkgsAdditionalCategories = {
  };

  allCategories = lib.foldl lib.recursiveUpdate {} [
    mainCategories
    additionalCategories
    reservedCategories
    nixpkgsAdditionalCategories
  ];
in
allCategories
