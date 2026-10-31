use std::env;

mod input;
mod mapper;
mod output;
mod util;

const EXE_DIR: &str = "/usr/local/bin";

fn main() {
    let binding = env::current_exe().unwrap();
    let current_path = binding.parent().unwrap().as_os_str();
    if current_path != EXE_DIR {
        panic!("Please move this executable to '{}'", EXE_DIR);
    }

    let mut op = "";

    let args = env::args().collect::<Vec<String>>();
    if args.len() == 1 {
        op = "capture"
    } else {
        op = args[1].as_str();
    }

    match op {
        "init" => {
            check_if_root();
            util::create_service_file(binding.as_os_str().to_str().unwrap());
        }

        "capture" => {
            check_if_root();
            let detected_events = input::find_mouse_events(false);
            output::start_capturing_events(detected_events)
        }

        "test" => {
            check_if_root();
            let detected_events = input::find_mouse_events(true);
            println!("events count: {}", detected_events.len());
            println!("start capturing events...");
            println!("If everything is OK, just run: mouse_fix init");
            output::start_capturing_events(detected_events);
        }

        "remove" => {
            check_if_root();
            util::remove_service_file();
        }

        "help" => {
            println!("A program to fix multi event mouse issue with creating with creating a virtual event file.");
            println!("  test:");
            println!("      to test without doing anything serious.");
            println!("  init:");
            println!("      to create service file and start at startup.");
            println!("  remove:");
            println!("      removes the created service file.");
            println!("\n<Developed by Benyamin Eskandari/>");
            println!("-- Website: https://me.benyaamin.com");
            println!("-- Github: @ItsBenyaamin");
        }

        _ => {}
    }
}

fn check_if_root() {
    match env::var("USER") {
        Ok(user) => {
            if user != "root" {
                panic!("Please run this program as root! Otherwise, It won't work.");
            }
        }
        Err(_) => {
            panic!("Unknown error on getting username!");
        }
    }
}
