#include <inja/inja.hpp>
#include <iostream>
#include <nlohmann/json.hpp>

int main() {
  nlohmann::json data = {{"name", "world"}};
  inja::render_to(std::cout, "Hello {{ name }}!", data);
}
