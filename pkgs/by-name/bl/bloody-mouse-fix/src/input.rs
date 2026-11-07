use std::collections::HashMap;
use std::fs;
use evdev_rs::*;
use evdev_rs::enums::EventType;

pub fn find_mouse_events(debug: bool) -> Vec<Device> {
    let events_list = fs::read_dir("/dev/input/").unwrap();
    let mut product_map: HashMap<String, i8> = HashMap::new();
    let mut mouse_events: Vec<Device> = vec![];

    if debug {
        println!("start looking for files...");
    }

    for ev_file in events_list {
        let path = ev_file.unwrap().path();
        if !&path.to_string_lossy().contains("event") {
            continue;
        }

        let event_file = Device::new_from_path(&path).unwrap();
        let has_rel_event_type = event_file.has(EventType::EV_REL);

        let device_name = event_file.name().unwrap();
        let product_id = event_file.product_id().to_string();

        if debug {
            println!(
                ">>> deviceName: {}, productId: {}, has relative event: {}",
                device_name, &product_id, has_rel_event_type
            );
        }

        if has_rel_event_type && !device_name.to_lowercase().contains("keyboard") {
            let exist = product_map.contains_key(&product_id);
            if exist {
                let last_count = product_map.get(&product_id).unwrap();
                product_map.insert(product_id, last_count + 1);
            } else {
                product_map.insert(product_id, 1);
            }
            mouse_events.push(event_file);

            if debug {
                println!("  ** candidate as mouse event, path: {}", path.to_string_lossy());
            }
        }
    }

    if debug {
        let products = &product_map.iter()
            .map(|(k, v)| format!("\n   id: {}, relatedFiles: {}", k.to_string(), v))
            .collect::<Vec<String>>()
            .join(",");
        println!("\nCandidate products: {}", products);
    }

    let chosen_product = product_map
        .iter()
        .max_by(|a, b| a.1.cmp(b.1))
        .map(|(k, _)| k)
        .unwrap();

    if debug {
        println!("Chosen productId as mouse event: {}", chosen_product);
    }

    mouse_events
        .into_iter()
        .filter(|v| v.product_id().to_string().eq(chosen_product))
        .map(|mut v| {
            v.grab(GrabMode::Grab).unwrap();
            v
        })
        .collect()
}